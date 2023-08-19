class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://files.pythonhosted.org/packages/c0/46/94ee6ba732a9e10977919ad23b5477e8ae14deb772d1c68ab150b03299cc/fonttools-4.42.0.tar.gz"
  sha256 "614b1283dca88effd20ee48160518e6de275ce9b5456a3134d5f235523fc5065"
  license "MIT"
  head "https://github.com/fonttools/fonttools.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "185a4c572cf6bda309b643d984ab86507edc56c92a3dad1c4309dd6e09670da9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "32959f26808d72874b3ff982b51dc1e31c63152a1f04d14897533c0b3cd1214f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b9715eb684c37bb4b7d929ad9927942c6e516d23e7f9101ce741d3b64791c70a"
    sha256 cellar: :any_skip_relocation, ventura:        "5c992aa5b526c9d9724ff2b0922e80bac08aeb02d90bc2df734096cc967d4503"
    sha256 cellar: :any_skip_relocation, monterey:       "a195606277a2fa175d165d8aace441709aa86ad71ae20a3ed436b93fc25c366e"
    sha256 cellar: :any_skip_relocation, big_sur:        "f274f3d68992b26c18f0886079a77fff26699495f6e214032d01041dc87d69a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7d9ee708df2cc810ed1f58edc5db2d8d48e1d01565788d3c5f06c3eaffa4dcf9"
  end

  depends_on "python@3.11"

  resource "brotli" do
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
