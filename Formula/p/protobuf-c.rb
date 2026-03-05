class ProtobufC < Formula
  desc "Protocol buffers library"
  homepage "https://github.com/protobuf-c/protobuf-c"
  url "https://github.com/protobuf-c/protobuf-c/releases/download/v1.5.2/protobuf-c-1.5.2.tar.gz"
  sha256 "e2c86271873a79c92b58fef7ebf8de1aa0df4738347a8bd5d4e65a80a16d0d24"
  license "BSD-2-Clause"
  revision 12

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "48996e72c65942fe6a8c5232430e2f47bc898095254b88f1746b85a8fbe058d0"
    sha256 cellar: :any, arm64_sequoia: "7d546d0e6f695b37020255b1ff7a0cc4470cd41891538c6c72a75dc109a267bb"
    sha256 cellar: :any, arm64_sonoma:  "039b508dab95a4c4d352351187a951e84b3a979d7732d4fa1a4a65aa833880da"
    sha256 cellar: :any, sonoma:        "5b88cb85c69afc9aae7a15f0b6690db720d6332f15e5e577f75f5074e3e469b6"
    sha256               arm64_linux:   "8ab0878b33fb294aecc3967836cf21eb0b5276cb55111567bdb3532495004271"
    sha256               x86_64_linux:  "26f89c7d7c5c7e0e46cc81f8da049a86cd69d02e35de2deacb02917a4ba5421a"
  end

  head do
    url "https://github.com/protobuf-c/protobuf-c.git", branch: "master"

    depends_on "asciidoc" => :build
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkgconf" => :build
  depends_on "abseil"
  depends_on "protobuf"

  patch :DATA

  def install
    system "autoreconf", "--force", "--install", "--verbose" if build.head?
    system "./configure", *std_configure_args
    system "make"
    system "make", "check" # run tests due to patch
    system "make", "install"
  end

  test do
    testdata = <<~PROTO
      syntax = "proto3";
      package test;
      message TestCase {
        string name = 4;
      }
      message Test {
        repeated TestCase case = 1;
      }
    PROTO
    (testpath/"test.proto").write testdata
    system Formula["protobuf@33"].opt_bin/"protoc", "test.proto", "--c_out=."

    testpath.glob("test.pb-c.*").map(&:unlink)
    system bin/"protoc-c", "test.proto", "--c_out=."
  end
end

__END__
diff --git a/protoc-gen-c/c_bytes_field.cc b/protoc-gen-c/c_bytes_field.cc
index c8ac772..ab10117 100644
--- a/protoc-gen-c/c_bytes_field.cc
+++ b/protoc-gen-c/c_bytes_field.cc
@@ -94,7 +94,7 @@ BytesFieldGenerator::~BytesFieldGenerator() {}
 
 void BytesFieldGenerator::GenerateStructMembers(google::protobuf::io::Printer* printer) const
 {
-  switch (descriptor_->label()) {
+  switch (FieldLabel(descriptor_)) {
     case google::protobuf::FieldDescriptor::LABEL_REQUIRED:
       printer->Print(variables_, "ProtobufCBinaryData $name$$deprecated$;\n");
       break;
@@ -135,7 +135,7 @@ std::string BytesFieldGenerator::GetDefaultValue(void) const
 }
 void BytesFieldGenerator::GenerateStaticInit(google::protobuf::io::Printer* printer) const
 {
-  switch (descriptor_->label()) {
+  switch (FieldLabel(descriptor_)) {
     case google::protobuf::FieldDescriptor::LABEL_REQUIRED:
       printer->Print(variables_, "$default_value$");
       break;
diff --git a/protoc-gen-c/c_enum_field.cc b/protoc-gen-c/c_enum_field.cc
index c3111f5..78ffb1c 100644
--- a/protoc-gen-c/c_enum_field.cc
+++ b/protoc-gen-c/c_enum_field.cc
@@ -95,7 +95,7 @@ EnumFieldGenerator::~EnumFieldGenerator() {}
 
 void EnumFieldGenerator::GenerateStructMembers(google::protobuf::io::Printer* printer) const
 {
-  switch (descriptor_->label()) {
+  switch (FieldLabel(descriptor_)) {
     case google::protobuf::FieldDescriptor::LABEL_REQUIRED:
       printer->Print(variables_, "$type$ $name$$deprecated$;\n");
       break;
@@ -117,7 +117,7 @@ std::string EnumFieldGenerator::GetDefaultValue(void) const
 }
 void EnumFieldGenerator::GenerateStaticInit(google::protobuf::io::Printer* printer) const
 {
-  switch (descriptor_->label()) {
+  switch (FieldLabel(descriptor_)) {
     case google::protobuf::FieldDescriptor::LABEL_REQUIRED:
       printer->Print(variables_, "$default$");
       break;
diff --git a/protoc-gen-c/c_field.cc b/protoc-gen-c/c_field.cc
index 8d22343..8f83e1b 100644
--- a/protoc-gen-c/c_field.cc
+++ b/protoc-gen-c/c_field.cc
@@ -125,11 +125,11 @@ void FieldGenerator::GenerateDescriptorInitializerGeneric(google::protobuf::io::
     variables["oneofname"] = CamelToLower(oneof->name());
 
   if (FieldSyntax(descriptor_) == 3 &&
-    descriptor_->label() == google::protobuf::FieldDescriptor::LABEL_OPTIONAL) {
+    FieldLabel(descriptor_) == google::protobuf::FieldDescriptor::LABEL_OPTIONAL) {
     variables["LABEL"] = "NONE";
     optional_uses_has = false;
   } else {
-    variables["LABEL"] = CamelToUpper(GetLabelName(descriptor_->label()));
+    variables["LABEL"] = CamelToUpper(GetLabelName(FieldLabel(descriptor_)));
   }
 
   if (descriptor_->has_default_value()) {
@@ -145,11 +145,11 @@ void FieldGenerator::GenerateDescriptorInitializerGeneric(google::protobuf::io::
 
   variables["flags"] = "0";
 
-  if (descriptor_->label() == google::protobuf::FieldDescriptor::LABEL_REPEATED
+  if (FieldLabel(descriptor_) == google::protobuf::FieldDescriptor::LABEL_REPEATED
    && is_packable_type (descriptor_->type())
    && descriptor_->options().packed()) {
     variables["flags"] += " | PROTOBUF_C_FIELD_FLAG_PACKED";
-  } else if (descriptor_->label() == google::protobuf::FieldDescriptor::LABEL_REPEATED
+  } else if (FieldLabel(descriptor_) == google::protobuf::FieldDescriptor::LABEL_REPEATED
    && is_packable_type (descriptor_->type())
    && FieldSyntax(descriptor_) == 3
    && !descriptor_->options().has_packed()) {
@@ -179,7 +179,7 @@ void FieldGenerator::GenerateDescriptorInitializerGeneric(google::protobuf::io::
     "  $value$,\n"
     "  PROTOBUF_C_LABEL_$LABEL$,\n"
     "  PROTOBUF_C_TYPE_$TYPE$,\n");
-  switch (descriptor_->label()) {
+  switch (FieldLabel(descriptor_)) {
     case google::protobuf::FieldDescriptor::LABEL_REQUIRED:
       printer->Print(variables, "  0,   /* quantifier_offset */\n");
       break;
diff --git a/protoc-gen-c/c_helpers.cc b/protoc-gen-c/c_helpers.cc
index e5c177c..d0c90dc 100644
--- a/protoc-gen-c/c_helpers.cc
+++ b/protoc-gen-c/c_helpers.cc
@@ -304,6 +304,16 @@ std::string FieldDeprecated(const google::protobuf::FieldDescriptor* field) {
   return "";
 }
 
+google::protobuf::FieldDescriptor::Label FieldLabel(const google::protobuf::FieldDescriptor* field) {
+  if (field->is_required()) {
+    return google::protobuf::FieldDescriptor::LABEL_REQUIRED;
+  } else if (field->is_repeated()) {
+    return google::protobuf::FieldDescriptor::LABEL_REPEATED;
+  } else {
+    return google::protobuf::FieldDescriptor::LABEL_OPTIONAL;
+  }
+}
+
 std::string StripProto(compat::StringView filename) {
   if (HasSuffixString(filename, ".protodevel")) {
     return StripSuffixString(filename, ".protodevel");
diff --git a/protoc-gen-c/c_helpers.h b/protoc-gen-c/c_helpers.h
index 6936999..e288b88 100644
--- a/protoc-gen-c/c_helpers.h
+++ b/protoc-gen-c/c_helpers.h
@@ -101,6 +101,8 @@ std::string FieldName(const google::protobuf::FieldDescriptor* field);
 // Get macro string for deprecated field
 std::string FieldDeprecated(const google::protobuf::FieldDescriptor* field);
 
+google::protobuf::FieldDescriptor::Label FieldLabel(const google::protobuf::FieldDescriptor* field);
+
 // Returns the scope where the field was defined (for extensions, this is
 // different from the message type to which the field applies).
 inline const google::protobuf::Descriptor* FieldScope(const google::protobuf::FieldDescriptor* field) {
diff --git a/protoc-gen-c/c_message_field.cc b/protoc-gen-c/c_message_field.cc
index 9fca920..4366135 100644
--- a/protoc-gen-c/c_message_field.cc
+++ b/protoc-gen-c/c_message_field.cc
@@ -83,7 +83,7 @@ void MessageFieldGenerator::GenerateStructMembers(google::protobuf::io::Printer*
   vars["name"] = FieldName(descriptor_);
   vars["type"] = FullNameToC(descriptor_->message_type()->full_name(), descriptor_->message_type()->file());
   vars["deprecated"] = FieldDeprecated(descriptor_);
-  switch (descriptor_->label()) {
+  switch (FieldLabel(descriptor_)) {
     case google::protobuf::FieldDescriptor::LABEL_REQUIRED:
     case google::protobuf::FieldDescriptor::LABEL_OPTIONAL:
       printer->Print(vars, "$type$ *$name$$deprecated$;\n");
@@ -103,7 +103,7 @@ std::string MessageFieldGenerator::GetDefaultValue(void) const
 }
 void MessageFieldGenerator::GenerateStaticInit(google::protobuf::io::Printer* printer) const
 {
-  switch (descriptor_->label()) {
+  switch (FieldLabel(descriptor_)) {
     case google::protobuf::FieldDescriptor::LABEL_REQUIRED:
     case google::protobuf::FieldDescriptor::LABEL_OPTIONAL:
       printer->Print("NULL");
diff --git a/protoc-gen-c/c_primitive_field.cc b/protoc-gen-c/c_primitive_field.cc
index 588f60e..b3a4a46 100644
--- a/protoc-gen-c/c_primitive_field.cc
+++ b/protoc-gen-c/c_primitive_field.cc
@@ -109,7 +109,7 @@ void PrimitiveFieldGenerator::GenerateStructMembers(google::protobuf::io::Printe
   vars["name"] = FieldName(descriptor_);
   vars["deprecated"] = FieldDeprecated(descriptor_);
 
-  switch (descriptor_->label()) {
+  switch (FieldLabel(descriptor_)) {
     case google::protobuf::FieldDescriptor::LABEL_REQUIRED:
       printer->Print(vars, "$c_type$ $name$$deprecated$;\n");
       break;
@@ -156,7 +156,7 @@ void PrimitiveFieldGenerator::GenerateStaticInit(google::protobuf::io::Printer*
   } else {
     vars["default_value"] = "0";
   }
-  switch (descriptor_->label()) {
+  switch (FieldLabel(descriptor_)) {
     case google::protobuf::FieldDescriptor::LABEL_REQUIRED:
       printer->Print(vars, "$default_value$");
       break;
diff --git a/protoc-gen-c/c_string_field.cc b/protoc-gen-c/c_string_field.cc
index 163f424..6aea8dd 100644
--- a/protoc-gen-c/c_string_field.cc
+++ b/protoc-gen-c/c_string_field.cc
@@ -94,7 +94,7 @@ void StringFieldGenerator::GenerateStructMembers(google::protobuf::io::Printer*
 {
   const ProtobufCFileOptions opt = descriptor_->file()->options().GetExtension(pb_c_file);
 
-  switch (descriptor_->label()) {
+  switch (FieldLabel(descriptor_)) {
     case google::protobuf::FieldDescriptor::LABEL_REQUIRED:
     case google::protobuf::FieldDescriptor::LABEL_OPTIONAL:
       if (opt.const_strings())
@@ -138,7 +138,7 @@ void StringFieldGenerator::GenerateStaticInit(google::protobuf::io::Printer* pri
   } else {
     vars["default"] = "(char *)protobuf_c_empty_string";
   }
-  switch (descriptor_->label()) {
+  switch (FieldLabel(descriptor_)) {
     case google::protobuf::FieldDescriptor::LABEL_REQUIRED:
     case google::protobuf::FieldDescriptor::LABEL_OPTIONAL:
       printer->Print(vars, "$default$");
