class ProtocGenGrpcWeb < Formula
  desc "Protoc plugin that generates code for gRPC-Web clients"
  homepage "https://github.com/grpc/grpc-web"
  url "https://github.com/grpc/grpc-web/archive/refs/tags/1.5.0.tar.gz"
  sha256 "d3043633f1c284288e98e44c802860ca7203c7376b89572b5f5a9e376c2392d5"
  license "Apache-2.0"
  revision 3

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "4e1817a688e9f5ec74def593de16f5655845e61b85ece1c4ce9ab0d2e9625bd1"
    sha256 cellar: :any,                 arm64_sonoma:  "aa3189a141759be26f4597954940bc2122576e27ccf49d4734058f17ba5a8a6b"
    sha256 cellar: :any,                 arm64_ventura: "b0ce3cd04dd533f588a6298639fdc92492ffe5a18749207365601136fa7a67e7"
    sha256 cellar: :any,                 sonoma:        "bae88a04ee0a095e4f402518720cbd033ace4e9c9ecb7457568f8f5957847dcf"
    sha256 cellar: :any,                 ventura:       "a767adc91038143a612954550756fc1c84e4204616a79694f811f9f6e8f4f641"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "90049dafe5518ec2987a4dfb3d1019cc95aa5c4746314ebd746d3cadd2f4840e"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "node" => :test
  depends_on "typescript" => :test
  depends_on "abseil"
  depends_on "protobuf"
  depends_on "protoc-gen-js"

  # Backport of https://github.com/grpc/grpc-web/commit/2c39859be8e5bcf55eef129e5a5330149ce460ab
  patch :DATA

  def install
    # Workarounds to build with latest `protobuf` which needs Abseil link flags and C++17
    ENV.append "LDFLAGS", Utils.safe_popen_read("pkg-config", "--libs", "protobuf").chomp
    inreplace "javascript/net/grpc/web/generator/Makefile", "-std=c++11", "-std=c++17"

    args = ["PREFIX=#{prefix}", "STATIC=no"]
    args << "MIN_MACOS_VERSION=#{MacOS.version}" if OS.mac?

    system "make", "install-plugin", *args
  end

  test do
    # First use the plugin to generate the files.
    testdata = <<~EOS
      syntax = "proto3";
      package test;
      message TestCase {
        string name = 4;
      }
      message Test {
        repeated TestCase case = 1;
      }
      message TestResult {
        bool passed = 1;
      }
      service TestService {
        rpc RunTest(Test) returns (TestResult);
      }
    EOS
    (testpath/"test.proto").write testdata
    system "protoc", "test.proto", "--plugin=#{bin}/protoc-gen-grpc-web",
                     "--js_out=import_style=commonjs:.",
                     "--grpc-web_out=import_style=typescript,mode=grpcwebtext:."

    # Now see if we can import them.
    testts = <<~EOS
      import * as grpcWeb from 'grpc-web';
      import {TestServiceClient} from './TestServiceClientPb';
      import {Test, TestResult} from './test_pb';
    EOS
    (testpath/"test.ts").write testts
    system "npm", "install", *std_npm_args(prefix: false), "grpc-web", "@types/google-protobuf"
    # Specify including lib for `tsc` since `es6` is required for `@types/google-protobuf`.
    system "tsc", "--lib", "es6", "test.ts"
  end
end

__END__
diff --git a/javascript/net/grpc/web/generator/grpc_generator.cc b/javascript/net/grpc/web/generator/grpc_generator.cc
index 158a335bb..1eb97b35d 100644
--- a/javascript/net/grpc/web/generator/grpc_generator.cc
+++ b/javascript/net/grpc/web/generator/grpc_generator.cc
@@ -841,13 +841,11 @@ void PrintProtoDtsMessage(Printer* printer, const Descriptor* desc,
                      "set$js_field_name$(value?: $js_field_type$): "
                      "$class_name$;\n");
     }
-    if (field->has_optional_keyword() ||
-        (field->type() == FieldDescriptor::TYPE_MESSAGE &&
-            !field->is_repeated() && !field->is_map())) {
+    if (field->has_presence()) {
       printer->Print(vars, "has$js_field_name$(): boolean;\n");
     }
-    if (field->type() == FieldDescriptor::TYPE_MESSAGE || field->has_optional_keyword() ||
-        field->is_repeated() || field->is_map()) {
+    if (field->type() == FieldDescriptor::TYPE_MESSAGE ||
+        field->has_presence() || field->is_repeated() || field->is_map()) {
       printer->Print(vars, "clear$js_field_name$(): $class_name$;\n");
     }
     if (field->is_repeated() && !field->is_map()) {
@@ -867,14 +865,12 @@ void PrintProtoDtsMessage(Printer* printer, const Descriptor* desc,
     printer->Print("\n");
   }

-  for (int i = 0; i < desc->oneof_decl_count(); i++) {
-    const OneofDescriptor* oneof = desc->oneof_decl(i);
-    if (!oneof->is_synthetic()) {
-      vars["js_oneof_name"] = ToUpperCamel(ParseLowerUnderscore(oneof->name()));
-      printer->Print(
-          vars, "get$js_oneof_name$Case(): $class_name$.$js_oneof_name$Case;\n");
-      printer->Print("\n");
-    }
+  for (int i = 0; i < desc->real_oneof_decl_count(); i++) {
+    const OneofDescriptor *oneof = desc->real_oneof_decl(i);
+    vars["js_oneof_name"] = ToUpperCamel(ParseLowerUnderscore(oneof->name()));
+    printer->Print(
+        vars, "get$js_oneof_name$Case(): $class_name$.$js_oneof_name$Case;\n");
+    printer->Print("\n");
   }

   printer->Print(
@@ -904,8 +900,7 @@ void PrintProtoDtsMessage(Printer* printer, const Descriptor* desc,
     }
     vars["js_field_name"] = js_field_name;
     vars["js_field_type"] = AsObjectFieldType(field, file);
-    if ((field->type() != FieldDescriptor::TYPE_MESSAGE && !field->has_optional_keyword()) ||
-        field->is_repeated()) {
+    if (!field->has_presence()) {
       printer->Print(vars, "$js_field_name$: $js_field_type$,\n");
     } else {
       printer->Print(vars, "$js_field_name$?: $js_field_type$,\n");
