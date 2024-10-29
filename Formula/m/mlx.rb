class Mlx < Formula
  include Language::Python::Virtualenv

  desc "Array framework for Apple silicon"
  homepage "https://github.com/ml-explore/mlx"
  url "https://github.com/ml-explore/mlx/archive/refs/tags/v0.19.1.tar.gz"
  sha256 "b6b76d5ddbe4ff7c667425fec2a67dc0abd258b734e708b1b45fd73910a2dc83"
  # Main license is MIT while `metal-cpp` resource is Apache-2.0
  license all_of: ["MIT", "Apache-2.0"]
  head "https://github.com/ml-explore/mlx.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_sequoia: "fae107bca31ed887a7453c0845d0c66f1cf45b18b09e0f7698e74f602880defb"
    sha256 cellar: :any, arm64_sonoma:  "a9b070476c444b7407224965cec8a49b12f02b92b042dae2e9d40ab12a2e6182"
    sha256 cellar: :any, arm64_ventura: "d7e79b2ea1eec1da86b1a885d4f2c22ff01473012358b6497b281b479db057dc"
    sha256 cellar: :any, sonoma:        "d6a32fecfa02768d75db1c0c946e6445b9352932f0d0d3610a460c770e13e52f"
    sha256 cellar: :any, ventura:       "338bd1feb8f6fe12e15088c988c8202065afd566f5fcab58deafb5800106a11f"
  end

  depends_on "cmake" => :build
  depends_on "fmt" => :build
  depends_on "nanobind" => :build
  depends_on "nlohmann-json" => :build
  depends_on "python-setuptools" => :build
  depends_on "robin-map" => :build
  depends_on :macos
  depends_on macos: :ventura
  depends_on "python@3.13"

  on_arm do
    depends_on xcode: ["15.0", :build] # for metal
  end

  on_intel do
    depends_on "openblas"
  end

  # https://github.com/ml-explore/mlx/blob/v#{version}/CMakeLists.txt#L91C21-L91C97
  # Included in not_a_binary_url_prefix_allowlist.json
  resource "metal-cpp" do
    on_arm do
      url "https://developer.apple.com/metal/cpp/files/metal-cpp_macOS15_iOS18-beta.zip"
      sha256 "d0a7990f43c7ce666036b5649283c9965df2f19a4a41570af0617bbe93b4a6e5"
    end
  end

  # Update to GIT_TAG at https://github.com/ml-explore/mlx/blob/v#{version}/mlx/io/CMakeLists.txt#L21
  resource "gguflib" do
    url "https://github.com/antirez/gguf-tools/archive/af7d88d808a7608a33723fba067036202910acb3.tar.gz"
    sha256 "1ee2dde74a3f9506af9ad61d7638a5e87b5e891b5e36a5dd3d5f412a8ce8dd03"
  end

  def python3
    "python3.13"
  end

  # Fix running tests in VMs.
  # https://github.com/ml-explore/mlx/pull/1537
  patch :DATA

  def install
    ENV.append_to_cflags "-I#{Formula["nlohmann-json"].opt_include}/nlohmann"
    (buildpath/"gguflib").install resource("gguflib")

    mlx_python_dir = prefix/Language::Python.site_packages(python3)/"mlx"

    # We bypass brew's dependency provider to set `FETCHCONTENT_TRY_FIND_PACKAGE_MODE`
    # which redirects FetchContent_Declare() to find_package() and helps find our `fmt`.
    # To re-block fetches, we use the not-recommended `FETCHCONTENT_FULLY_DISCONNECTED`.
    args = %W[
      -DCMAKE_MODULE_LINKER_FLAGS=-Wl,-rpath,#{rpath(source: mlx_python_dir)}
      -DHOMEBREW_ALLOW_FETCHCONTENT=ON
      -DFETCHCONTENT_FULLY_DISCONNECTED=ON
      -DFETCHCONTENT_TRY_FIND_PACKAGE_MODE=ALWAYS
      -DFETCHCONTENT_SOURCE_DIR_GGUFLIB=#{buildpath}/gguflib
    ]
    args << if Hardware::CPU.arm?
      (buildpath/"metal_cpp").install resource("metal-cpp")
      "-DFETCHCONTENT_SOURCE_DIR_METAL_CPP=#{buildpath}/metal_cpp"
    else
      "-DMLX_ENABLE_X64_MAC=ON"
    end

    ENV["CMAKE_ARGS"] = (args + std_cmake_args).join(" ")
    ENV[build.head? ? "DEV_RELEASE" : "PYPI_RELEASE"] = "1"
    ENV["MACOSX_DEPLOYMENT_TARGET"] = "#{MacOS.version.major}.#{MacOS.version.minor.to_i}"

    system python3, "-m", "pip", "install", *std_pip_args, "."
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <cassert>

      #include <mlx/mlx.h>

      int main() {
        mlx::core::array x({1.0f, 2.0f, 3.0f, 4.0f}, {2, 2});
        mlx::core::array y = mlx::core::ones({2, 2});
        mlx::core::array z = mlx::core::add(x, y);
        mlx::core::eval(z);
        assert(z.dtype() == mlx::core::float32);
        assert(z.shape(0) == 2);
        assert(z.shape(1) == 2);
        assert(z.data<float>()[0] == 2.0f);
        assert(z.data<float>()[1] == 3.0f);
        assert(z.data<float>()[2] == 4.0f);
        assert(z.data<float>()[3] == 5.0f);
      }
    EOS
    system ENV.cxx, "test.cpp", "-std=c++17",
                    "-I#{include}", "-L#{lib}", "-lmlx",
                    "-o", "test"
    system "./test"

    (testpath/"test.py").write <<~EOS
      import mlx.core as mx
      x = mx.array(0.0)
      assert mx.cos(x) == 1.0
    EOS
    system python3, "test.py"
  end
end

__END__
diff --git a/mlx/backend/metal/resident.cpp b/mlx/backend/metal/resident.cpp
index 403857c6..819d803b 100644
--- a/mlx/backend/metal/resident.cpp
+++ b/mlx/backend/metal/resident.cpp
@@ -1,5 +1,8 @@
 // Copyright © 2024 Apple Inc.
 
+#include <sys/sysctl.h>
+#include <cstddef>
+
 #include "mlx/backend/metal/resident.h"
 #include "mlx/backend/metal/metal_impl.h"
 
@@ -8,8 +11,23 @@ namespace mlx::core::metal {
 // TODO maybe worth including tvos / visionos
 #define supported __builtin_available(macOS 15, iOS 18, *)
 
+// Trying to create a residency set in a VM leads to errors.
+static bool in_vm() {
+  auto check_vm = []() {
+    int hv_vmm_present = 0;
+
+    std::size_t len = sizeof(hv_vmm_present);
+    sysctlbyname("kern.hv_vmm_present", &hv_vmm_present, &len, NULL, 0);
+
+    return hv_vmm_present;
+  };
+
+  static int in_vm = check_vm();
+  return in_vm;
+}
+
 ResidencySet::ResidencySet(MTL::Device* d) {
-  if (supported) {
+  if (supported && !in_vm()) {
     auto pool = new_scoped_memory_pool();
     auto desc = MTL::ResidencySetDescriptor::alloc()->init();
     NS::Error* error;
@@ -27,7 +45,7 @@ ResidencySet::ResidencySet(MTL::Device* d) {
 }
 
 void ResidencySet::insert(MTL::Allocation* buf) {
-  if (supported) {
+  if (supported && !in_vm()) {
     if (wired_set_->allocatedSize() + buf->allocatedSize() <= capacity_) {
       wired_set_->addAllocation(buf);
       wired_set_->commit();
@@ -39,7 +57,7 @@ void ResidencySet::insert(MTL::Allocation* buf) {
 }
 
 void ResidencySet::erase(MTL::Allocation* buf) {
-  if (supported) {
+  if (supported && !in_vm()) {
     if (auto it = unwired_set_.find(buf); it != unwired_set_.end()) {
       unwired_set_.erase(it);
     } else {
@@ -50,7 +68,7 @@ void ResidencySet::erase(MTL::Allocation* buf) {
 }
 
 void ResidencySet::resize(size_t size) {
-  if (supported) {
+  if (supported && !in_vm()) {
     if (capacity_ == size) {
       return;
     }
@@ -88,7 +106,7 @@ void ResidencySet::resize(size_t size) {
 }
 
 ResidencySet::~ResidencySet() {
-  if (supported) {
+  if (supported && !in_vm()) {
     wired_set_->release();
   }
 }
