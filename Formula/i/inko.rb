class Inko < Formula
  desc "Safe and concurrent object-oriented programming language"
  homepage "https://inko-lang.org/"
  license "MPL-2.0"

  stable do
    url "https://releases.inko-lang.org/0.18.1.tar.gz"
    sha256 "498d7062ab2689850f56f5a85f5331115a8d1bee147e87c0fdfe97894bc94d80"

    depends_on "llvm@17" # TODO: update LLVM version on next release

    # Workaround for Rust 1.8.0+, remove with next release
    patch :DATA
  end

  # The upstream website doesn't provide easily accessible version information
  # or link to release tarballs, so we check the release manifest file that
  # the Inko version manager (`ivm`) uses.
  livecheck do
    url "https://releases.inko-lang.org/manifest.txt"
    regex(/^v?(\d+(?:\.\d+)+)$/im)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "61eb97a6c71d33389ac906a5d69f143172f61d78a91b91c667e50e71a0604f19"
    sha256 cellar: :any,                 arm64_sequoia: "ee26a0c11c1c527151fde51739a7f4fe5ac5f721805deb98e1a5f2bd3024d038"
    sha256 cellar: :any,                 arm64_sonoma:  "44fc95eba234a04e7cfe132a17874892a86fdcf0b198a07de3ca5807fdead3be"
    sha256 cellar: :any,                 arm64_ventura: "e61d4dd6bacfdb7d01a885493de960998271cf10f6bf4931a2deecef27a59eec"
    sha256 cellar: :any,                 sonoma:        "487151f34bc632c5d5618cb65d06efd23afd8f8dac3becf13f2b2597e18aa4e5"
    sha256 cellar: :any,                 ventura:       "f4b935a853326a2422c5f2bb826c765d9cfa27dd32ebf8005e1d1f7bdbdd58f9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "578ff3eacb96844be7e983fd7c8bf8c7481138ea12425cbdd9cf2c95e317060a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7af46ba20d2d34d8d5ec23574d97caa98a50278eca21fd9e1573856cf58ee24f"
  end

  head do
    url "https://github.com/inko-lang/inko.git", branch: "main"
    depends_on "llvm"
  end

  depends_on "rust" => :build

  uses_from_macos "libffi", since: :catalina

  def install
    # Avoid statically linking to LLVM
    inreplace "compiler/Cargo.toml", 'prefer-static"]', 'force-dynamic"]'

    system "make", "build", "PREFIX=#{prefix}"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    (testpath/"hello.inko").write <<~INKO
      import std.stdio (Stdout)

      type async Main {
        fn async main {
          Stdout.new.print('Hello, world!')
        }
      }
    INKO
    assert_equal "Hello, world!\n", shell_output("#{bin}/inko run hello.inko")
  end
end

__END__
diff --git a/compiler/src/llvm/abi/generic.rs b/compiler/src/llvm/abi/generic.rs
index 528ec23..4e039f8 100644
--- a/compiler/src/llvm/abi/generic.rs
+++ b/compiler/src/llvm/abi/generic.rs
@@ -10,7 +10,7 @@ pub(crate) enum Class {
 }
 
 impl Class {
-    pub(crate) fn to_llvm_type(self, context: &Context) -> BasicTypeEnum {
+    pub(crate) fn to_llvm_type(self, context: &Context) -> BasicTypeEnum<'_> {
         match self {
             Class::Int(bytes) => {
                 context.custom_int(bytes as u32 * 8).as_basic_type_enum()
diff --git a/compiler/src/llvm/context.rs b/compiler/src/llvm/context.rs
index b08e879..9fd6726 100644
--- a/compiler/src/llvm/context.rs
+++ b/compiler/src/llvm/context.rs
@@ -59,39 +59,39 @@ impl Context {
         self.inner.ptr_type(AddressSpace::default())
     }
 
-    pub(crate) fn bool_type(&self) -> IntType {
+    pub(crate) fn bool_type(&self) -> IntType<'_> {
         self.inner.bool_type()
     }
 
-    pub(crate) fn custom_int(&self, bits: u32) -> IntType {
+    pub(crate) fn custom_int(&self, bits: u32) -> IntType<'_> {
         self.inner.custom_width_int_type(bits)
     }
 
-    pub(crate) fn i8_type(&self) -> IntType {
+    pub(crate) fn i8_type(&self) -> IntType<'_> {
         self.inner.i8_type()
     }
 
-    pub(crate) fn i16_type(&self) -> IntType {
+    pub(crate) fn i16_type(&self) -> IntType<'_> {
         self.inner.i16_type()
     }
 
-    pub(crate) fn i32_type(&self) -> IntType {
+    pub(crate) fn i32_type(&self) -> IntType<'_> {
         self.inner.i32_type()
     }
 
-    pub(crate) fn i64_type(&self) -> IntType {
+    pub(crate) fn i64_type(&self) -> IntType<'_> {
         self.inner.i64_type()
     }
 
-    pub(crate) fn f32_type(&self) -> FloatType {
+    pub(crate) fn f32_type(&self) -> FloatType<'_> {
         self.inner.f32_type()
     }
 
-    pub(crate) fn f64_type(&self) -> FloatType {
+    pub(crate) fn f64_type(&self) -> FloatType<'_> {
         self.inner.f64_type()
     }
 
-    pub(crate) fn void_type(&self) -> VoidType {
+    pub(crate) fn void_type(&self) -> VoidType<'_> {
         self.inner.void_type()
     }
 
@@ -114,7 +114,7 @@ impl Context {
         self.inner.struct_type(fields, false)
     }
 
-    pub(crate) fn two_words(&self) -> StructType {
+    pub(crate) fn two_words(&self) -> StructType<'_> {
         let word = self.i64_type().into();
 
         self.inner.struct_type(&[word, word], false)
@@ -165,11 +165,11 @@ impl Context {
         self.inner.append_basic_block(function, "")
     }
 
-    pub(crate) fn create_builder(&self) -> Builder {
+    pub(crate) fn create_builder(&self) -> Builder<'_> {
         self.inner.create_builder()
     }
 
-    pub(crate) fn create_module(&self, name: &str) -> Module {
+    pub(crate) fn create_module(&self, name: &str) -> Module<'_> {
         self.inner.create_module(name)
     }
 
diff --git a/compiler/src/mir/pattern_matching.rs b/compiler/src/mir/pattern_matching.rs
index 32207be..602577f 100644
--- a/compiler/src/mir/pattern_matching.rs
+++ b/compiler/src/mir/pattern_matching.rs
@@ -916,7 +916,7 @@ mod tests {
             .collect()
     }
 
-    fn compiler(state: &mut State) -> Compiler {
+    fn compiler(state: &mut State) -> Compiler<'_> {
         Compiler::new(state, Variables::new(), TypeBounds::new())
     }
 
diff --git a/compiler/src/pkg/sync.rs b/compiler/src/pkg/sync.rs
index 563f54b..3cb75f8 100644
--- a/compiler/src/pkg/sync.rs
+++ b/compiler/src/pkg/sync.rs
@@ -105,7 +105,7 @@ fn download_dependency(
     })?;
 
     if tag.target != dependency.checksum.to_string() {
-        format!(
+        let _ = format!(
             "The checksum of {} version {} didn't match.
 
 The checksum that is expected is:
diff --git a/rt/src/process.rs b/rt/src/process.rs
index 6e9ebb2..3c4c975 100644
--- a/rt/src/process.rs
+++ b/rt/src/process.rs
@@ -540,7 +540,7 @@ impl Process {
         }
     }
 
-    pub(crate) fn state(&self) -> MutexGuard<ProcessState> {
+    pub(crate) fn state(&self) -> MutexGuard<'_, ProcessState> {
         self.state.lock().unwrap()
     }
 
diff --git a/rt/src/runtime.rs b/rt/src/runtime.rs
index 34c84a9..272421e 100644
--- a/rt/src/runtime.rs
+++ b/rt/src/runtime.rs
@@ -105,7 +105,7 @@ pub unsafe extern "system" fn inko_runtime_state(
 pub unsafe extern "system" fn inko_runtime_stack_mask(
     runtime: *mut Runtime,
 ) -> u64 {
-    let raw_size = (*runtime).state.config.stack_size;
+    let raw_size = (&(*runtime)).state.config.stack_size;
     let total = total_stack_size(raw_size as _, page_size()) as u64;
 
     !(total - 1)
diff --git a/rt/src/runtime/byte_array.rs b/rt/src/runtime/byte_array.rs
index a6aa7fb..15e96a1 100644
--- a/rt/src/runtime/byte_array.rs
+++ b/rt/src/runtime/byte_array.rs
@@ -55,7 +55,7 @@ pub unsafe extern "system" fn inko_byte_array_get(
     bytes: *mut ByteArray,
     index: i64,
 ) -> i64 {
-    *(*bytes).value.get_unchecked(index as usize) as i64
+    *(&(*bytes).value).get_unchecked(index as usize) as i64
 }
 
 #[no_mangle]
diff --git a/rt/src/runtime/process.rs b/rt/src/runtime/process.rs
index 9f4864f..591c7e0 100644
--- a/rt/src/runtime/process.rs
+++ b/rt/src/runtime/process.rs
@@ -162,7 +162,7 @@ pub unsafe extern "system" fn inko_process_stack_frame_name(
     trace: *const Vec<StackFrame>,
     index: i64,
 ) -> *const InkoString {
-    let val = &(*trace).get_unchecked(index as usize).name;
+    let val = &(&(*trace)).get_unchecked(index as usize).name;
 
     InkoString::alloc((*state).string_type, val.clone())
 }
@@ -173,7 +173,7 @@ pub unsafe extern "system" fn inko_process_stack_frame_path(
     trace: *const Vec<StackFrame>,
     index: i64,
 ) -> *const InkoString {
-    let val = &(*trace).get_unchecked(index as usize).path;
+    let val = &(&(*trace)).get_unchecked(index as usize).path;
 
     InkoString::alloc((*state).string_type, val.clone())
 }
@@ -183,7 +183,7 @@ pub unsafe extern "system" fn inko_process_stack_frame_line(
     trace: *const Vec<StackFrame>,
     index: i64,
 ) -> i64 {
-    (*trace).get_unchecked(index as usize).line
+    (&(*trace)).get_unchecked(index as usize).line
 }
 
 #[no_mangle]
diff --git a/types/src/lib.rs b/types/src/lib.rs
index a34f565..a9486ea 100644
--- a/types/src/lib.rs
+++ b/types/src/lib.rs
@@ -565,7 +565,7 @@ impl TypeArguments {
         self.mapping.is_empty()
     }
 
-    pub fn iter(&self) -> indexmap::map::Iter<TypeParameterId, TypeRef> {
+    pub fn iter(&self) -> indexmap::map::Iter<'_, TypeParameterId, TypeRef> {
         self.mapping.iter()
     }
 }
