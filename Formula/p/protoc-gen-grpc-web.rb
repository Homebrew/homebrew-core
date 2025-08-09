class ProtocGenGrpcWeb < Formula
  desc "Protoc plugin that generates code for gRPC-Web clients"
  homepage "https://github.com/grpc/grpc-web"
  url "https://github.com/grpc/grpc-web/archive/refs/tags/1.5.0.tar.gz"
  sha256 "d3043633f1c284288e98e44c802860ca7203c7376b89572b5f5a9e376c2392d5"
  license "Apache-2.0"
  revision 12

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "0886a33d0116b5c4c26a717b4c8d3165e6650cc4f9f54a327b79a81fccf4371a"
    sha256 cellar: :any,                 arm64_sonoma:  "abaf853a0373ee0e4a4d7c6fa114476e1adcd6a6fec56a5d4e24dc9913f391f9"
    sha256 cellar: :any,                 arm64_ventura: "fc26c89c84d709b2d6d329e47288739727cb577135cfab1c076415d3f83b4b52"
    sha256 cellar: :any,                 sonoma:        "1ffc0b4b1b795113adf41fa1c884f86207a8acaec17233bd5ae0b98052c3b311"
    sha256 cellar: :any,                 ventura:       "3c2cf35bf37367c24fa06378495df5c44a49116f7d33ff56a9a9065d80f89d5b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "89279bdfc7d047258abd71b3544af1a7f72d153b8de5b7ab6f17c0dc28a61e75"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "db475c7703f351e481d4811340a77a239fe846d81681ec15dab2f469446a30f3"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "node" => :test
  depends_on "typescript" => :test
  depends_on "abseil"
  depends_on "protobuf@29"
  depends_on "protoc-gen-js"

  # Backport of https://github.com/grpc/grpc-web/commit/2c39859be8e5bcf55eef129e5a5330149ce460ab
  patch :DATA

  def install
    # Workarounds to build with latest `protobuf` which needs Abseil link flags and C++17
    ENV.append "LDFLAGS", Utils.safe_popen_read("pkgconf", "--libs", "protobuf").chomp
    inreplace "javascript/net/grpc/web/generator/Makefile", "-std=c++11", "-std=c++17"

    args = ["PREFIX=#{prefix}", "STATIC=no"]
    args << "MIN_MACOS_VERSION=#{MacOS.version}" if OS.mac?

    system "make", "install-plugin", *args
  end

  test do
    # First use the plugin to generate the files.
    (testpath/"test.proto").write <<~PROTO
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
    PROTO
    protoc = Formula["protobuf@29"].bin/"protoc"
    system protoc, "test.proto", "--plugin=#{bin}/protoc-gen-grpc-web",
                   "--js_out=import_style=commonjs:.",
                   "--grpc-web_out=import_style=typescript,mode=grpcwebtext:."

    # Now see if we can import them.
    (testpath/"test.ts").write <<~TYPESCRIPT
      import * as grpcWeb from 'grpc-web';
      import {TestServiceClient} from './TestServiceClientPb';
      import {Test, TestResult} from './test_pb';
    TYPESCRIPT
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
