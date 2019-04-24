class MoltenVk < Formula
  desc "Implementation of the Vulkan graphics and compute API on top of Metal"
  homepage "https://github.com/KhronosGroup/MoltenVK"
  url "https://github.com/KhronosGroup/MoltenVK/archive/v1.0.34.tar.gz"
  sha256 "a687007c1049fe8277b181c5e403776518e81a8e642af920a135649a058f165b"

  depends_on "cmake" => :build
  # Requires IOSurface/IOSurfaceRef.h.
  depends_on :macos => :sierra

  # MoltenVK depends on very specific revisions of its dependencies.
  # For each resource the path to the file describing the expected
  # revision is listed.
  resource "cereal" do
    # ExternalRevisions/cereal_repo_revision
    url "https://github.com/USCiLab/cereal.git",
        :revision => "51cbda5f30e56c801c07fe3d3aba5d7fb9e6cca4"
  end

  resource "vulkan-headers" do
    # ExternalRevisions/Vulkan-Headers_repo_revision
    url "https://github.com/KhronosGroup/Vulkan-Headers.git",
        :revision => "08cbb5458f692d4778806775f65eb3dc642ddbbf"
  end

  resource "vulkan-portability" do
    # ExternalRevisions/Vulkan-Portability_repo_revision
    url "https://github.com/KhronosGroup/Vulkan-Portability.git",
        :revision => "53be040f04ce55463d0e5b25fd132f45f003e903"
  end

  resource "spirv-cross" do
    # ExternalRevisions/SPIRV-Cross_repo_revision
    url "https://github.com/KhronosGroup/SPIRV-Cross.git",
        :revision => "ac5a9570a744eb72725c23c34f36fbc564c0bb51"
  end

  resource "glslang" do
    # ExternalRevisions/glslang_repo_revision
    url "https://github.com/KhronosGroup/glslang.git",
        :revision => "e06c7e9a515b716c731bda13f507546f107775d1"
  end

  resource "spirv-tools" do
    # External/glslang/known_good.json
    url "https://github.com/KhronosGroup/SPIRV-Tools.git",
        :revision => "26c1b8878315a7a5c188df45e0bc236bb222b698"
  end

  resource "spirv-headers" do
    # External/glslang/known_good.json
    url "https://github.com/KhronosGroup/SPIRV-Headers.git",
        :revision => "2434b89345a50c018c84f42a310b0fad4f3fd94f"
  end

  resource "vulkan-tools" do
    # ExternalRevisions/Vulkan-Tools_repo_revision
    url "https://github.com/KhronosGroup/Vulkan-Tools.git",
        :revision => "2abb69904b9ad017d39d3da1e7fc3dec1a584cd8"
  end

  def install
    (buildpath/"External/cereal").install resource("cereal")
    (buildpath/"External/Vulkan-Headers").install resource("vulkan-headers")
    (buildpath/"External/Vulkan-Portability").install resource("vulkan-portability")
    (buildpath/"External/SPIRV-Cross").install resource("spirv-cross")
    (buildpath/"External/glslang").install resource("glslang")
    (buildpath/"External/glslang/External/SPIRV-Tools").install resource("spirv-tools")
    (buildpath/"External/glslang/External/SPIRV-Tools/External/SPIRV-Headers").install resource("spirv-headers")
    (buildpath/"External/Vulkan-Tools").install resource("vulkan-tools")

    mkdir "External/glslang/External/SPIRV-Tools/build" do
      # Required due to files being generated during build.
      system "cmake", "..", *std_cmake_args
      system "make"
    end

    xcodebuild "-project", "ExternalDependencies.xcodeproj",
               "-scheme", "ExternalDependencies-macOS",
               "-derivedDataPath", "External/build",
               "build"

    xcodebuild "-project", "MoltenVKPackaging.xcodeproj",
               "-scheme", "MoltenVK Package (macOS only)",
               "build"

    frameworks.install "Package/Release/MoltenVK/macOS/framework/MoltenVK.framework"
    lib.install "Package/Release/MoltenVK/macOS/dynamic/libMoltenVK.dylib"
    frameworks.install "Package/Release/MoltenVKShaderConverter/MoltenVKGLSLToSPIRVConverter/macOS/framework/MoltenVKGLSLToSPIRVConverter.framework"
    frameworks.install "Package/Release/MoltenVKShaderConverter/MoltenVKSPIRVToMSLConverter/macOS/framework/MoltenVKSPIRVToMSLConverter.framework"
    bin.install "Package/Release/MoltenVKShaderConverter/Tools/MoltenVKShaderConverter"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <vulkan/vulkan.h>
      int main(void)
      {
        const char *extensionNames[] = { "VK_KHR_surface" };
        VkInstanceCreateInfo instanceCreateInfo = {
          VK_STRUCTURE_TYPE_INSTANCE_CREATE_INFO, NULL,
          0, NULL,
          0, NULL,
          1, extensionNames,
        };
        VkInstance inst;
        vkCreateInstance(&instanceCreateInfo, NULL, &inst);
        return 0;
      }
    EOS
    system ENV.cc, "-o", "test", "test.cpp", "-L#{lib}", "-lMoltenVK"
    system "./test"
  end
end
