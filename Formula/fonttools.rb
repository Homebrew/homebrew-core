class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://files.pythonhosted.org/packages/53/95/655180bd8c0baaad32241a42f3f81e4f2754164e7ec11233cdae8457f2db/fonttools-4.37.4.zip"
  sha256 "86918c150c6412798e15a0de6c3e0d061ddefddd00f97b4f7b43dfa867ad315e"
  license "MIT"
  head "https://github.com/fonttools/fonttools.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ee592ac0efdb50edebe6103bf1f61b66c791b38eb07f71f4496fc231d23e1889"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "965ac8700247c689c37836ee20c33f5b238c540686e3d8f5dcbdc2f97f8828e5"
    sha256 cellar: :any_skip_relocation, monterey:       "ef3f6fa71b50b61fc83d7168ab8a8a61a9f8e16ae029d886d326e03e83f6694c"
    sha256 cellar: :any_skip_relocation, big_sur:        "ad51edc441d2275401216cf789a3e2eb74c7536b7e474a2a6a289315894095e1"
    sha256 cellar: :any_skip_relocation, catalina:       "796ae2b44ea6730f600453f8a0ced466bd582991b985bb8b92b802492fa54158"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3d4d71c7589682ebffc54fd642e33db9ff95877c45b65767e138df165af34214"
  end

  depends_on "python@3.10"

  resource "Brotli" do
    url "https://files.pythonhosted.org/packages/2a/18/70c32fe9357f3eea18598b23aa9ed29b1711c3001835f7cf99a9818985d0/Brotli-1.0.9.zip"
    sha256 "4d1b810aa0ed773f81dceda2cc7b403d01057458730e309856356d4ef4188438"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    if OS.mac?
      cp "/System/Library/Fonts/ZapfDingbats.ttf", testpath
      system bin/"ttx", "ZapfDingbats.ttf"
      system bin/"fonttools", "ttLib.woff2", "compress", "ZapfDingbats.ttf"
    else
      assert_match "usage", shell_output("#{bin}/ttx -h")
    end
  end
end
