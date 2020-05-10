class Blockdiag < Formula
  include Language::Python::Virtualenv

  desc "Generate block-diagram images from .diag files"
  homepage "http://blockdiag.com/en/"
  url "https://files.pythonhosted.org/packages/b6/1b/eab880ae3e6c7e24ae5adecc40ee7dd05c9ebb0dff6c39b52472844ce9b7/blockdiag-2.0.1.tar.gz"
  sha256 "16a69dd9f3b44c9e0869999ce82aa968586698febc86ece9ca0c902dba772397"

  depends_on "freetype"
  depends_on "imagemagick"
  depends_on "jpeg"
  depends_on "libtiff"
  depends_on "little-cms2"
  depends_on "python"
  depends_on "webp"
  
  uses_from_macos "zlib"

  resource "funcparserlib" do
    url "https://files.pythonhosted.org/packages/cb/f7/b4a59c3ccf67c0082546eaeb454da1a6610e924d2e7a2a21f337ecae7b40/funcparserlib-0.3.6.tar.gz"
    sha256 "b7992eac1a3eb97b3d91faa342bfda0729e990bd8a43774c1592c091e563c91d"
  end
  resource "reportlab" do
    url "https://files.pythonhosted.org/packages/74/0b/34dc83ed0108417358716d218eec8528b24c30597570a71cab929bce2432/reportlab-3.5.42.tar.gz"
    sha256 "9c21f202697a6cea57b9d716288fc919d99cbabeb30222eebfc7ff77eac32744"
  end
  resource "wand" do
    url "https://files.pythonhosted.org/packages/a3/ff/22a74061e56888c8813c4c86274e166f71a1305ea76dd4c75fcd14e51dd3/Wand-0.5.9.tar.gz"
    sha256 "6eaca78e53fbe329b163f0f0b28f104de98edbd69a847268cc5d6a6e392b9b28"
  end
  resource "Pillow" do
    url "https://files.pythonhosted.org/packages/39/47/f28067b187dd664d205f75b07dcc6e0e95703e134008a14814827eebcaab/Pillow-7.0.0.tar.gz"
    sha256 "4d9ed9a64095e031435af120d3c910148067087541131e82b3e8db302f4c8946"
  end
  resource "webcolors" do
    url "https://files.pythonhosted.org/packages/a7/df/b97bf02a97bbd5ed874fec7c5418bf0dd51e8d042ac46bbf2bf5983e89fd/webcolors-1.11.1.tar.gz"
    sha256 "76f360636957d1c976db7466bc71dcb713bb95ac8911944dffc55c01cb516de6"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"test.diag").write <<~EOS
      blockdiag {
        // Set fontsize
        default_fontsize = 20;  // default value is 11

        A -> B [label = "large"];
        B -> C [label = "small", fontsize = 11];  // change fontsize of edge-label

        A [fontsize = 32];  // change fontsize of node-label

        group {
          label = "group label";
          fontsize = 16;  // change fontsize of group-label

          C;
        }
      }
    EOS
    system "#{bin}/blockdiag", "-a", "test.diag"
    # output is test.png, but how do I verify good png?
  end
end
