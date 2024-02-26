class Kin < Formula
  include Language::Python::Virtualenv

  desc "Sane PBXProj files"
  homepage "https://github.com/Serchinastico/Kin"
  url "https://files.pythonhosted.org/packages/fb/99/49be90a495d0044a9ecadedb2b44c294489d249f65058ffd4575f6b55c95/kin-2.1.8.tar.gz"
  sha256 "5ba16dbb9f28b38a73a5cda71f477bf198e2c078a134c2cc7a51ba8703f84428"
  license "Apache-2.0"
  head "https://github.com/Serchinastico/Kin.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8561d56906fe5e791c47583652b4ae0a8e763a99e20721b4fe8d431fb2e1061b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ddc8f9d7b9f588cf2d6612995b613e0fab47fd89a345e0528a82f5cf9e6e2dc4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d752587cbae0ca55d3abef627f4868a41f9bd8fb400abd41d3e3cc7c936d427e"
    sha256 cellar: :any_skip_relocation, sonoma:         "7f2bd1301e6e055808ee3550677b817ce31728321f4364669b7b200563db91f5"
    sha256 cellar: :any_skip_relocation, ventura:        "cac32fec242bab35b2c7a7675720d6a1b210beaa99bc214d88bb366a37b440e7"
    sha256 cellar: :any_skip_relocation, monterey:       "ee034b9e8dca4352709afdff44886e1db4409eb82577b5aa687e7b1382bbf502"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d6a2de0278557c397127022f7c981a567585eb4dd580a59a8bb3a4c170f71ddb"
  end

  depends_on "python@3.12"

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
    output = shell_output("#{bin}/kin Good.xcodeproj/project.pbxproj")
    assert_match output, "CORRECT\n"
  end
end
