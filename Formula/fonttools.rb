class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://files.pythonhosted.org/packages/53/95/655180bd8c0baaad32241a42f3f81e4f2754164e7ec11233cdae8457f2db/fonttools-4.37.4.zip"
  sha256 "86918c150c6412798e15a0de6c3e0d061ddefddd00f97b4f7b43dfa867ad315e"
  license "MIT"
  head "https://github.com/fonttools/fonttools.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cb84097002859ceafc5a7e440e8e770e6a096c02fc3fc2a65b67f283b2bef9b4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2317c6ff0069a0b3bc34a8c9e0bd3d96d23a777000ff8061a2587e3d0e70c361"
    sha256 cellar: :any_skip_relocation, monterey:       "76a35f9d1f83c813a03f66185a0883c3993d4e052c496a6e5e8c8f7b71ac18d8"
    sha256 cellar: :any_skip_relocation, big_sur:        "5c3695ad59e3b4b0ad04f44a6ce5a1b9f6296bcab75c0e3dcfd4dc3846328ff4"
    sha256 cellar: :any_skip_relocation, catalina:       "33e51fc7f45f3e2abb47d7edee02db377a20b22f3968bdca5997c1db55cb3cfc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "33a37880755f7edea08f0956098d7bde84dd6d6ef257dbb51fd3dfc9e92ada17"
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
