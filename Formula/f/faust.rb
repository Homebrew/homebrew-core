class Faust < Formula
  desc "Functional programming language for real time signal processing"
  homepage "https://faust.grame.fr"
  url "https://github.com/grame-cncm/faust/releases/download/2.81.2/faust-2.81.2.tar.gz"
  sha256 "c91afe17cc01f1f75e4928dc2d2971dd83b37d10be991dda7e8b94ffab1f1ac9"
  license "GPL-2.0-or-later"
  revision 1

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "3e337f0ad78a144961265bac26dcda9e84a0ea9b5f2a260a6ea72f32d923aad0"
    sha256 cellar: :any,                 arm64_sequoia: "aafdddadada9756ff0238186fa7bf0fefbd79e669ea4aa7e1b40e86d21dce96a"
    sha256 cellar: :any,                 arm64_sonoma:  "5053f847c93970cd6afb6fbabd4ebb3fb0a549d33df09d3863b5e9dfa97258b9"
    sha256                               sonoma:        "8e925300b4d5bffb5e0f62c1f8e2c541809c3fe8462db3dfc68ba246564b8bff"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8c2487e5a12802bb6708a644c1de36da96f42176ad4e75470b65608e9522809e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9e5c10c3174fa3a69f42829a698df8bb51abc034cc469abf1cc841ef77d7054a"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "libmicrohttpd"
  depends_on "libsndfile"
  depends_on "llvm"

  # Backport support for LLVM 21. Skipping wasm whitespace changes in:
  # https://github.com/grame-cncm/faust/commit/0b773c503ce77a753579c52ecf2531845ae7532a
  patch :DATA

  def install
    # `brew linkage` doesn't like the pre-built Android libsndfile.so for faust2android.
    # Not an essential feature so just remove it when building arm64 linux in CI.
    if ENV["HOMEBREW_GITHUB_ACTIONS"].present? && OS.linux? && Hardware::CPU.arm?
      rm("architecture/android/app/lib/libsndfile/lib/arm64-v8a/libsndfile.so")
    end

    system "cmake", "-S", "build", "-B", "homebrew_build",
                    "-DC_BACKEND=COMPILER DYNAMIC",
                    "-DCODEBOX_BACKEND=COMPILER DYNAMIC",
                    "-DCPP_BACKEND=COMPILER DYNAMIC",
                    "-DCMAJOR_BACKEND=COMPILER DYNAMIC",
                    "-DCSHARP_BACKEND=COMPILER DYNAMIC",
                    "-DDLANG_BACKEND=COMPILER DYNAMIC",
                    "-DFIR_BACKEND=COMPILER DYNAMIC",
                    "-DINTERP_BACKEND=COMPILER DYNAMIC",
                    "-DJAVA_BACKEND=COMPILER DYNAMIC",
                    "-DJAX_BACKEND=COMPILER DYNAMIC",
                    "-DJULIA_BACKEND=COMPILER DYNAMIC",
                    "-DJSFX_BACKEND=COMPILER DYNAMIC",
                    "-DLLVM_BACKEND=COMPILER DYNAMIC",
                    "-DOLDCPP_BACKEND=COMPILER DYNAMIC",
                    "-DRUST_BACKEND=COMPILER DYNAMIC",
                    "-DTEMPLATE_BACKEND=OFF",
                    "-DWASM_BACKEND=COMPILER DYNAMIC WASM",
                    "-DINCLUDE_EXECUTABLE=ON",
                    "-DINCLUDE_STATIC=OFF",
                    "-DINCLUDE_DYNAMIC=ON",
                    "-DINCLUDE_OSC=OFF",
                    "-DINCLUDE_HTTP=OFF",
                    "-DOSCDYNAMIC=ON",
                    "-DHTTPDYNAMIC=ON",
                    "-DINCLUDE_ITP=OFF",
                    "-DITPDYNAMIC=ON",
                    "-DLINK_LLVM_STATIC=OFF",
                    *std_cmake_args
    system "cmake", "--build", "homebrew_build"
    system "cmake", "--install", "homebrew_build"

    system "make", "--directory=tools/sound2faust", "PREFIX=#{prefix}"
    system "make", "--directory=tools/sound2faust", "install", "PREFIX=#{prefix}"
  end

  test do
    (testpath/"noise.dsp").write <<~EOS
      import("stdfaust.lib");
      process = no.noise;
    EOS

    system bin/"faust", "noise.dsp"
  end
end

__END__
diff --git a/compiler/generator/llvm/llvm_code_container.cpp b/compiler/generator/llvm/llvm_code_container.cpp
index 827360940b..c1abacb3fa 100644
--- a/compiler/generator/llvm/llvm_code_container.cpp
+++ b/compiler/generator/llvm/llvm_code_container.cpp
@@ -90,7 +90,12 @@ void LLVMCodeContainer::init(const string& name, int numInputs, int numOutputs,
         fBuilder->setFastMathFlags(FMF);
     }
 
+#if LLVM_VERSION_MAJOR >= 21
+    llvm::Triple TT(llvm::sys::getDefaultTargetTriple());
+    fModule->setTargetTriple(TT);
+#else
     fModule->setTargetTriple(sys::getDefaultTargetTriple());
+#endif
 }
 
 LLVMCodeContainer::~LLVMCodeContainer()
diff --git a/compiler/generator/llvm/llvm_code_container.hh b/compiler/generator/llvm/llvm_code_container.hh
index e97230a1f8..c0e5c503aa 100644
--- a/compiler/generator/llvm/llvm_code_container.hh
+++ b/compiler/generator/llvm/llvm_code_container.hh
@@ -55,7 +55,11 @@ class LLVMCodeContainer : public virtual CodeContainer {
     template <typename REAL>
     void generateGetJSON()
     {
-        LLVMPtrType         string_ptr = llvm::PointerType::get(fBuilder->getInt8Ty(), 0);
+#if LLVM_VERSION_MAJOR >= 21
+        LLVMPtrType string_ptr = llvm::PointerType::get(fModule->getContext(), 0);
+#else
+        LLVMPtrType string_ptr = llvm::PointerType::get(fBuilder->getInt8Ty(), 0);
+#endif
         LLVMVecTypes        getJSON_args;
         llvm::FunctionType* getJSON_type =
             llvm::FunctionType::get(string_ptr, makeArrayRef(getJSON_args), false);
diff --git a/compiler/generator/llvm/llvm_dynamic_dsp_aux.cpp b/compiler/generator/llvm/llvm_dynamic_dsp_aux.cpp
index d7bca74eea..a6a71e20cf 100644
--- a/compiler/generator/llvm/llvm_dynamic_dsp_aux.cpp
+++ b/compiler/generator/llvm/llvm_dynamic_dsp_aux.cpp
@@ -296,7 +296,12 @@ bool llvm_dynamic_dsp_factory_aux::initJIT(string& error_msg)
 
     string triple, cpu;
     splitTarget(fTarget, triple, cpu);
+#if LLVM_VERSION_MAJOR >= 21
+    llvm::Triple TT(triple);
+    fModule->setTargetTriple(TT);
+#else
     fModule->setTargetTriple(triple);
+#endif
 
     builder.setMCPU((cpu == "") ? sys::getHostCPUName() : StringRef(cpu));
     TargetOptions targetOptions;
@@ -485,7 +490,13 @@ bool llvm_dynamic_dsp_factory_aux::writeDSPFactoryToObjectcodeFileAux(
     const string& object_code_path)
 {
     auto TargetTriple = sys::getDefaultTargetTriple();
+#if LLVM_VERSION_MAJOR >= 21
+    llvm::Triple TT(TargetTriple);
+    fModule->setTargetTriple(TT);
+#else
     fModule->setTargetTriple(TargetTriple);
+#endif
+
     string Error;
     auto   Target = TargetRegistry::lookupTarget(TargetTriple, Error);
 
diff --git a/compiler/generator/llvm/llvm_instructions.hh b/compiler/generator/llvm/llvm_instructions.hh
index 9e5b001d41..80dadcef22 100644
--- a/compiler/generator/llvm/llvm_instructions.hh
+++ b/compiler/generator/llvm/llvm_instructions.hh
@@ -216,8 +216,13 @@ struct LLVMTypeHelper {
     LLVMType getInt64Ty() { return llvm::Type::getInt64Ty(fModule->getContext()); }
     LLVMType getInt1Ty() { return llvm::Type::getInt1Ty(fModule->getContext()); }
     LLVMType getInt8Ty() { return llvm::Type::getInt8Ty(fModule->getContext()); }
+#if LLVM_VERSION_MAJOR >= 21
+    LLVMType getInt8TyPtr() { return llvm::PointerType::get(fModule->getContext(), 0); }
+    LLVMType getTyPtr(LLVMType type) { return llvm::PointerType::get(fModule->getContext(), 0); }
+#else
     LLVMType getInt8TyPtr() { return llvm::PointerType::get(getInt8Ty(), 0); }
     LLVMType getTyPtr(LLVMType type) { return llvm::PointerType::get(type, 0); }
+#endif
 
     /*
         Return the pointee type:
