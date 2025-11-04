class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://files.pythonhosted.org/packages/4b/42/97a13e47a1e51a5a7142475bbcf5107fe3a68fc34aef331c897d5fb98ad0/fonttools-4.60.1.tar.gz"
  sha256 "ef00af0439ebfee806b25f24c8f92109157ff3fac5731dc7867957812e87b8d9"
  license "MIT"
  revision 1
  head "https://github.com/fonttools/fonttools.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "15c0f815274279adaccda8da7447099c2cf0c6a48d1d265422b765177dcaf140"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fd9bdb261eba38f01da918b4c51aab21d8e52b27380000bbb30e194719eb69bc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5df016a7a7ebc9e2c835b44625b08d880901ba721dddcecca9986dce4c3ac547"
    sha256 cellar: :any_skip_relocation, sonoma:        "17eac0a58d3c06cad0b5591699a51de1c5bb2d81ad3ba4c87a5439c7477e6097"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0bae2b4e45bf04b5fc707431f691bd30ce1d4b8b2480b21df8d1fb45b6de20c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e92f98edbcda6155e54809a1d4f4dcc08db76794d99c5b96e291df691df2a38f"
  end

  depends_on "python@3.14"

  uses_from_macos "libxml2"
  uses_from_macos "libxslt"

  pypi_packages package_name: "fonttools[lxml,woff]"

  resource "brotli" do
    url "https://files.pythonhosted.org/packages/2f/c2/f9e977608bdf958650638c3f1e28f85a1b075f075ebbe77db8555463787b/Brotli-1.1.0.tar.gz"
    sha256 "81de08ac11bcb85841e440c13611c00b67d3bf82698314928d0b676362546724"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/aa/88/262177de60548e5a2bfc46ad28232c9e9cbde697bd94132aeb80364675cb/lxml-6.0.2.tar.gz"
    sha256 "cd79f3367bd74b317dda655dc8fcfa304d9eb6e4fb06b7168c5cf27f96e0cd62"
  end

  resource "zopfli" do
    url "https://files.pythonhosted.org/packages/5e/7c/a8f6696e694709e2abcbccd27d05ef761e9b6efae217e11d977471555b62/zopfli-0.2.3.post1.tar.gz"
    sha256 "96484dc0f48be1c5d7ae9f38ed1ce41e3675fd506b27c11a6607f14b49101e99"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    if OS.mac?
      cp "/System/Library/Fonts/ZapfDingbats.ttf", testpath

      system bin/"ttx", "ZapfDingbats.ttf"
      assert_path_exists testpath/"ZapfDingbats.ttx"
      system bin/"fonttools", "ttLib.woff2", "compress", "ZapfDingbats.ttf"
      assert_path_exists testpath/"ZapfDingbats.woff2"
    else
      assert_match "usage", shell_output("#{bin}/ttx -h")
    end
  end
end
