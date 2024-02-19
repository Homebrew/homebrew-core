class Kin < Formula
  include Language::Python::Virtualenv

  desc "Sane PBXProj files"
  homepage "https://github.com/Serchinastico/Kin"
  url "https://files.pythonhosted.org/packages/77/ac/067a8e8c11a6400045199bdd6e4cdaa6d90e98eb35f3a8bc4c81a1560ec4/kin-2.1.6.tar.gz"
  sha256 "1433126fd10db61161327fa19435a0cce61c116672e2133092c404e7fb91fdb1"
  license "Apache-2.0"
  head "https://github.com/Serchinastico/Kin.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c18b30fe63a931ce39a351a56757d056f8cb8eb65afcb66915da95473119ec81"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a68442572da54214562be750571ce8523e44f3ebe27dd34974f0995bb4112bd4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fe35cbc07de38118dc432ca0ed8f90e1560234e9e0f96ff861d9fc123993ba25"
    sha256 cellar: :any_skip_relocation, sonoma:         "6c0067848905a9e285758c23a5a58b7f0abc8cdb3996ca843f4d9d14349ed478"
    sha256 cellar: :any_skip_relocation, ventura:        "828ebe0b72e6689e961f0f0d1d1cd21a5703f942213cb8a8bba81785a44036b6"
    sha256 cellar: :any_skip_relocation, monterey:       "c1b9a596f879be72d378fd5d230dc0565933537c695cd966cd867704f34a5b9b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d74221f7f0650cad1b5add5a690012ade87146f477f946e9886321d5def43556"
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
