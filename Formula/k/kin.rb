class Kin < Formula
  include Language::Python::Virtualenv

  desc "Sane PBXProj files"
  homepage "https://github.com/Serchinastico/Kin"
  url "https://files.pythonhosted.org/packages/71/8c/f3916cf3cbc3785ebca47506d50e3b586516f58331832682035a4e23f18c/kin-2.1.14.tar.gz"
  sha256 "de2c22863a2a5e6eedbe88dc351b913b7666b16528020e6178a72f1e85e1b2d9"
  license "Apache-2.0"
  head "https://github.com/Serchinastico/Kin.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "a8a5be63c8cd244537431fb248dafd7d566aca1ab83dfd7d65e7ce6c62b76675"
  end

  depends_on "python@3.14"

  resource "antlr4-python3-runtime" do
    url "https://files.pythonhosted.org/packages/b6/00/7f1cab9b44518ca225a03f4493ac9294aab5935a7a28486ba91a20ea29cf/antlr4-python3-runtime-4.13.1.tar.gz"
    sha256 "3cd282f5ea7cfb841537fe01f143350fdb1c0b1ce7981443a2fa8513fddb6d1a"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"Good.xcodeproj/project.pbxproj").write <<~EOS
      {
        archiveVersion = 1;
        classes = {};
        objectVersion = 46;
        objects = {
          FE870E28DC2371E7ACA886F03F460581 = {isa = PBXFileReference; explicitFileType = text.xcconfig; name = "Something.xcconfig"; path = "Configurations/Something.xcconfig"; sourceTree = "<group>"; };
          78452DDA02BFEF5D6BA29AEFB4B1266A = {isa = PBXGroup; children = (FE870E28DC2371E7ACA886F03F460581,); name = Configurations; sourceTree = "<group>"; };
          49FBBF861C10C2A200A1A4BB = {isa = PBXProject; buildConfigurationList = 49FBBF891C10C2A200A1A4BB; compatibilityVersion = "Xcode 3.2"; hasScannedForEncodings = 0; mainGroup = 49FBBF851C10C2A200A1A4BB; productRefGroup = 49FBBF8F1C10C2A200A1A4BB; projectDirPath = ""; projectRoot = ""; targets = (49FBBF8D1C10C2A200A1A4BB, 4973659B1C19BC6E00837617,); };
          49FBBF951C10C2A200A1A4BB = {isa = PBXVariantGroup; children = (49FBBF961C10C2A200A1A4BB,); name = Main.storyboard; sourceTree = "<group>"; };
          49FBBF9A1C10C2A200A1A4BB = {isa = PBXVariantGroup; children = (49FBBF9B1C10C2A200A1A4BB,); name = LaunchScreen.storyboard; sourceTree = "<group>"; };
          497365A41C19BC6E00837617 = {isa = XCBuildConfiguration; baseConfigurationReference = 274E42B0193BA6FEFA8FD71C; buildSettings = { FRAMEWORK_SEARCH_PATHS = ("$(inherited)", "$(PROJECT_DIR)/build/Debug-iphoneos",); }; name = Debug; };
          49FBBFB61C10C2A200A1A4BB = {isa = XCConfigurationList; buildConfigurations = (49FBBFB71C10C2A200A1A4BB, 49FBBFB81C10C2A200A1A4BB,); defaultConfigurationIsVisible = 0; defaultConfigurationName = Release; };
        };
        rootObject = 49FBBF861C10C2A200A1A4BB;
      }
    EOS
    assert_match "CORRECT\n", shell_output("#{bin}/kin Good.xcodeproj/project.pbxproj")
  end
end
