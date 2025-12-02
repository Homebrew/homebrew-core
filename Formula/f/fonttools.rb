class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://files.pythonhosted.org/packages/33/f9/0e84d593c0e12244150280a630999835a64f2852276161b62a0f98318de0/fonttools-4.61.0.tar.gz"
  sha256 "ec520a1f0c7758d7a858a00f090c1745f6cde6a7c5e76fb70ea4044a15f712e7"
  license "MIT"
  head "https://github.com/fonttools/fonttools.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "28e4e7067b237c29004b50859dfc6383f9cf69d11d21f68652450a956f5ca1e1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4480de382ad75d469c2bbece0d0036c25d058d975b96fa7e30ea47ee57d81c99"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dc8850b5399ec4377e65ae62a0409d6a0e92394c377e6f6404d52fd2321f2515"
    sha256 cellar: :any_skip_relocation, sonoma:        "de829c6260ff879ed4c0e41f88794013ea9050a0fe1408d4b4d0539a02f56764"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "154b15da99accef1ef717da2fa85098e2332e862aca3eadc2b00c145b404d094"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "879420adef68c8b3d7ec3d85e8fc84a11fab4a6a5330b0dd2aeea81d92f2700f"
  end

  depends_on "python@3.14"

  uses_from_macos "libxml2"
  uses_from_macos "libxslt"

  pypi_packages package_name: "fonttools[lxml,woff]"

  resource "brotli" do
    url "https://files.pythonhosted.org/packages/f7/16/c92ca344d646e71a43b8bb353f0a6490d7f6e06210f8554c8f874e454285/brotli-1.2.0.tar.gz"
    sha256 "e310f77e41941c13340a95976fe66a8a95b01e783d430eeaf7a2f87e0a57dd0a"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/aa/88/262177de60548e5a2bfc46ad28232c9e9cbde697bd94132aeb80364675cb/lxml-6.0.2.tar.gz"
    sha256 "cd79f3367bd74b317dda655dc8fcfa304d9eb6e4fb06b7168c5cf27f96e0cd62"
  end

  resource "zopfli" do
    url "https://files.pythonhosted.org/packages/be/4c/efa0760686d4cc69e68a8f284d3c6c5884722c50f810af0e277fb7d61621/zopfli-0.4.0.tar.gz"
    sha256 "a8ee992b2549e090cd3f0178bf606dd41a29e0613a04cdf5054224662c72dce6"
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
