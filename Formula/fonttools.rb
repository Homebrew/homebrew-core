class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://files.pythonhosted.org/packages/9a/fe/0c77652d275fa4dfb887b72c7c149aba71153b618c73d62ada1527d2f0ef/fonttools-4.37.1.zip"
  sha256 "4606e1a88ee1f6699d182fea9511bd9a8a915d913eab4584e5226da1180fcce7"
  license "MIT"
  head "https://github.com/fonttools/fonttools.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ac9b2ad08856501803f72f744da89d448dc5f42bc7a449b2bfe3d6a741c3e375"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0a6bf0ac97c2b882ab48d875bbdfa2a340efb671dc87cbd6ab4648285e42ca22"
    sha256 cellar: :any_skip_relocation, monterey:       "0055e4a50fe0c0c22b71a9e43ebedcab42f500008ef9a190f528be221cadafd6"
    sha256 cellar: :any_skip_relocation, big_sur:        "9e37dff95d3781336248d8ac242543126f7a505e57fce63a42be6ef7269aaf81"
    sha256 cellar: :any_skip_relocation, catalina:       "9d5f299f54f80aae55389647fdbe605d7efb0300f50bbe3c61249f74587caffc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3b2444f61d5487bf58fccf4865cead4bf4ef4a229b403a81e2c694489fd99dad"
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
