class MoltenVk < Formula
  desc "Implementation of the Vulkan graphics and compute API on top of Metal"
  homepage "https://github.com/KhronosGroup/MoltenVK"
  license "Apache-2.0"

  stable do
    url "https://github.com/KhronosGroup/MoltenVK/archive/refs/tags/v1.4.1.tar.gz"
    sha256 "9985f141902a17de818e264d17c1ce334b748e499ee02fcb4703e4dc0038f89c"

    # MoltenVK depends on very specific revisions of its dependencies.
    # For each resource the path to the file describing the expected
    # revision is listed.
    resource "SPIRV-Cross" do
      # ExternalRevisions/SPIRV-Cross_repo_revision
      url "https://github.com/KhronosGroup/SPIRV-Cross.git",
          revision: "adec7acbf41a988713cdb85f93f26c8ca5ea863e"
      version "adec7acbf41a988713cdb85f93f26c8ca5ea863e"

      livecheck do
        url "https://raw.githubusercontent.com/KhronosGroup/MoltenVK/refs/tags/v#{LATEST_VERSION}/ExternalRevisions/SPIRV-Cross_repo_revision"
        regex(/^([0-9a-f]+)$/i)
      end
    end

    resource "SPIRV-Headers" do
      # ExternalRevisions/SPIRV-Headers_repo_revision
      url "https://github.com/KhronosGroup/SPIRV-Headers.git",
          revision: "b824a462d4256d720bebb40e78b9eb8f78bbb305"
      version "b824a462d4256d720bebb40e78b9eb8f78bbb305"

      livecheck do
        url "https://raw.githubusercontent.com/KhronosGroup/MoltenVK/refs/tags/v#{LATEST_VERSION}/ExternalRevisions/SPIRV-Headers_repo_revision"
        regex(/^([0-9a-f]+)$/i)
      end
    end

    resource "SPIRV-Tools" do
      # ExternalRevisions/SPIRV-Tools_repo_revision
      url "https://github.com/KhronosGroup/SPIRV-Tools.git",
          revision: "262bdab48146c937467f826699a40da0fdfc0f1a"
      version "262bdab48146c937467f826699a40da0fdfc0f1a"

      livecheck do
        url "https://raw.githubusercontent.com/KhronosGroup/MoltenVK/refs/tags/v#{LATEST_VERSION}/ExternalRevisions/SPIRV-Tools_repo_revision"
        regex(/^([0-9a-f]+)$/i)
      end
    end

    resource "Vulkan-Headers" do
      # ExternalRevisions/Vulkan-Headers_repo_revision
      url "https://github.com/KhronosGroup/Vulkan-Headers.git",
          revision: "6aefb8eb95c8e170d0805fd0f2d02832ec1e099a"
      version "6aefb8eb95c8e170d0805fd0f2d02832ec1e099a"

      livecheck do
        url "https://raw.githubusercontent.com/KhronosGroup/MoltenVK/refs/tags/v#{LATEST_VERSION}/ExternalRevisions/Vulkan-Headers_repo_revision"
        regex(/^([0-9a-f]+)$/i)
      end
    end

    resource "Vulkan-Tools" do
      # ExternalRevisions/Vulkan-Tools_repo_revision
      url "https://github.com/KhronosGroup/Vulkan-Tools.git",
          revision: "013058f74e2356347f8d9317233bc769816c9dfb"
      version "013058f74e2356347f8d9317233bc769816c9dfb"

      livecheck do
        url "https://raw.githubusercontent.com/KhronosGroup/MoltenVK/refs/tags/v#{LATEST_VERSION}/ExternalRevisions/Vulkan-Tools_repo_revision"
        regex(/^([0-9a-f]+)$/i)
      end
    end

    resource "cereal" do
      # ExternalRevisions/cereal_repo_revision
      url "https://github.com/USCiLab/cereal.git",
          revision: "a56bad8bbb770ee266e930c95d37fff2a5be7fea"
      version "a56bad8bbb770ee266e930c95d37fff2a5be7fea"

      livecheck do
        url "https://raw.githubusercontent.com/KhronosGroup/MoltenVK/refs/tags/v#{LATEST_VERSION}/ExternalRevisions/cereal_repo_revision"
        regex(/^([0-9a-f]+)$/i)
      end
    end
  end

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "c582142652134e00fcddb2b15491492020469d0efc497873b017c45b2ba21a3b"
    sha256 cellar: :any, arm64_sequoia: "9b8177214626a66d3f3d437263fdb5b90617ebabc58a72748eda09024c139c38"
    sha256 cellar: :any, arm64_sonoma:  "fb9f58d36dc493741ba4c5dba69704d29f0dcba0732f2308402be1eabac4d706"
    sha256 cellar: :any, arm64_ventura: "bad2cf52dea78a3561653620af14993927bb1b6873e308b5a9ff3fe8c1cd532b"
    sha256 cellar: :any, sonoma:        "9a16c4a69f8cbb94bea95004f0c686a645df1c3c35ec5fbee23ae0edb9298078"
    sha256 cellar: :any, ventura:       "998675bdd180f03a6acb2a8c908826452f912fde846c3442cf9b821ad004067a"
  end

  head do
    url "https://github.com/KhronosGroup/MoltenVK.git", branch: "main"

    resource "SPIRV-Cross" do
      url "https://github.com/KhronosGroup/SPIRV-Cross.git", branch: "main"
    end

    resource "SPIRV-Headers" do
      url "https://github.com/KhronosGroup/SPIRV-Headers.git", branch: "main"
    end

    resource "SPIRV-Tools" do
      url "https://github.com/KhronosGroup/SPIRV-Tools.git", branch: "main"
    end

    resource "Vulkan-Headers" do
      url "https://github.com/KhronosGroup/Vulkan-Headers.git", branch: "main"
    end

    resource "Vulkan-Tools" do
      url "https://github.com/KhronosGroup/Vulkan-Tools.git", branch: "main"
    end

    resource "cereal" do
      url "https://github.com/USCiLab/cereal.git", branch: "master"
    end
  end

  depends_on "cmake" => :build
  depends_on xcode: ["11.7", :build]
  depends_on :macos # Linux does not have a Metal implementation. Not implied by the line above.

  uses_from_macos "python" => :build

  def install
    resources.each do |res|
      res.stage(buildpath/"External"/res.name)
    end

    # Build spirv-tools
    mv "External/SPIRV-Headers", "External/spirv-tools/external/spirv-headers"

    mkdir "External/spirv-tools" do
      system "cmake", "-S", ".", "-B", "build", *std_cmake_args
      system "cmake", "--build", "build"
    end

    # Build ExternalDependencies
    xcodebuild "ARCHS=#{Hardware::CPU.arch}", "ONLY_ACTIVE_ARCH=YES",
               "-project", "ExternalDependencies.xcodeproj",
               "-scheme", "ExternalDependencies-macOS",
               "-derivedDataPath", "External/build",
               "SYMROOT=External/build", "OBJROOT=External/build",
               "build"

    if DevelopmentTools.clang_build_version >= 1500 && MacOS.version < :sonoma
      # Required to build xcframeworks with Xcode 15
      # https://github.com/KhronosGroup/MoltenVK/issues/2028
      xcodebuild "-create-xcframework", "-output", "./External/build/Release/SPIRVCross.xcframework",
                "-library", "./External/build/Release/libSPIRVCross.a"
      xcodebuild "-create-xcframework", "-output", "./External/build/Release/SPIRVTools.xcframework",
                "-library", "./External/build/Release/libSPIRVTools.a"
    end

    # Build MoltenVK Package
    xcodebuild "ARCHS=#{Hardware::CPU.arch}", "ONLY_ACTIVE_ARCH=YES",
               "-project", "MoltenVKPackaging.xcodeproj",
               "-scheme", "MoltenVK Package (macOS only)",
               "-derivedDataPath", "#{buildpath}/build",
               "SYMROOT=#{buildpath}/build", "OBJROOT=build",
               "GCC_PREPROCESSOR_DEFINITIONS=${inherited} MVK_CONFIG_LOG_LEVEL=MVK_CONFIG_LOG_LEVEL_NONE",
               "build"

    (libexec/"lib").install Dir["External/build/Release/" \
                                "lib{SPIRVCross,SPIRVTools}.a"]

    (libexec/"include").install "External/SPIRV-Cross/include/spirv_cross"
    (libexec/"include").install "External/SPIRV-Tools/include/spirv-tools"
    (libexec/"include").install "External/Vulkan-Headers/include/vulkan" => "vulkan"
    (libexec/"include").install "External/Vulkan-Headers/include/vk_video" => "vk_video"

    frameworks.install "Package/Release/MoltenVK/static/MoltenVK.xcframework"
    lib.install "Package/Release/MoltenVK/dylib/macOS/libMoltenVK.dylib"
    lib.install "build/Release/libMoltenVK.a"
    include.install "MoltenVK/MoltenVK/API" => "MoltenVK"

    bin.install "Package/Release/MoltenVKShaderConverter/Tools/MoltenVKShaderConverter"
    frameworks.install "Package/Release/MoltenVKShaderConverter/" \
                       "MoltenVKShaderConverter.xcframework"
    include.install Dir["Package/Release/MoltenVKShaderConverter/include/" \
                        "MoltenVKShaderConverter"]

    inreplace "MoltenVK/icd/MoltenVK_icd.json",
              "./libMoltenVK.dylib",
              (lib/"libMoltenVK.dylib").relative_path_from(prefix/"etc/vulkan/icd.d")
    (prefix/"etc/vulkan").install "MoltenVK/icd" => "icd.d"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <vulkan/vulkan.h>
      int main(void) {
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
    CPP
    system ENV.cc, "-o", "test", "test.cpp", "-I#{include}", "-I#{libexec/"include"}", "-L#{lib}", "-lMoltenVK"
    system "./test"
  end
end
