class Kin < Formula
  include Language::Python::Virtualenv

  desc "Sane PBXProj files"
  homepage "https://github.com/Serchinastico/Kin"
  url "https://files.pythonhosted.org/packages/ab/a6/fe193e6193675c978b493ebe8e6a606b52203e37463179ca573ebcaa18dd/kin-2.1.9.tar.gz"
  sha256 "35da507e45b733a6f391676b47995b26ca40afcb38fcb5c3f5e0d90101027dee"
  license "Apache-2.0"
  head "https://github.com/Serchinastico/Kin.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6b2ba72f179e81c3f94fb5cbf045c1a60e6560a1ec27bb80832aba1a2ba62ae1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6b2ba72f179e81c3f94fb5cbf045c1a60e6560a1ec27bb80832aba1a2ba62ae1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6b2ba72f179e81c3f94fb5cbf045c1a60e6560a1ec27bb80832aba1a2ba62ae1"
    sha256 cellar: :any_skip_relocation, sonoma:         "6b2ba72f179e81c3f94fb5cbf045c1a60e6560a1ec27bb80832aba1a2ba62ae1"
    sha256 cellar: :any_skip_relocation, ventura:        "6b2ba72f179e81c3f94fb5cbf045c1a60e6560a1ec27bb80832aba1a2ba62ae1"
    sha256 cellar: :any_skip_relocation, monterey:       "6b2ba72f179e81c3f94fb5cbf045c1a60e6560a1ec27bb80832aba1a2ba62ae1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "747006dfd30eb91047cae53ab11532077a0e50908c45270172187f6de8dbc833"
  end

  depends_on "python@3.12"

  resource "antlr4-python3-runtime" do
    url "https://files.pythonhosted.org/packages/b6/00/7f1cab9b44518ca225a03f4493ac9294aab5935a7a28486ba91a20ea29cf/antlr4-python3-runtime-4.13.1.tar.gz"
    sha256 "3cd282f5ea7cfb841537fe01f143350fdb1c0b1ce7981443a2fa8513fddb6d1a"
  end

  # Drop unneeded argparse requirement: https://github.com/Serchinastico/Kin/pull/115
  patch do
    url "https://github.com/Serchinastico/Kin/commit/02251e6babc56e3b3d5dfda18559d2f86f147975.patch?full_index=1"
    sha256 "838b4e9fe54c9afcff0f38a6b6f1eda83883ff724c7089bfa08521f96615fbca"
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
