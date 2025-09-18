class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://files.pythonhosted.org/packages/27/d9/4eabd956fe123651a1f0efe29d9758b3837b5ae9a98934bdb571117033bb/fonttools-4.60.0.tar.gz"
  sha256 "8f5927f049091a0ca74d35cce7f78e8f7775c83a6901a8fbe899babcc297146a"
  license "MIT"
  head "https://github.com/fonttools/fonttools.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3186e5de0d890fe4c3c31ee253b1ace9294868d88c3c7874599acedf6f8da7b0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "811e1fc712124c9b01df14f896520ffafc740c2362758d3b9c637aa67012eda3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "39806f1faf9a2be1da7dbcf793c88207dbe112e48407e4ff4e72db1eb6a805ca"
    sha256 cellar: :any_skip_relocation, sonoma:        "8b82230c02202ab523adb99cae9921985ca98fc0be9eeec52f12968e41a1bce0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ca41de3cf64b8af634806ba80c72dfada7000b9b1ccb042e44707c1168d92f0a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2a6d47aaf06ab12bac9d65de222e0332365f6674da94fa7aa942f3e8f349c59e"
  end

  depends_on "python@3.13"

  uses_from_macos "libxml2"
  uses_from_macos "libxslt"

  resource "brotli" do
    url "https://files.pythonhosted.org/packages/2f/c2/f9e977608bdf958650638c3f1e28f85a1b075f075ebbe77db8555463787b/Brotli-1.1.0.tar.gz"
    sha256 "81de08ac11bcb85841e440c13611c00b67d3bf82698314928d0b676362546724"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/8f/bd/f9d01fd4132d81c6f43ab01983caea69ec9614b913c290a26738431a015d/lxml-6.0.1.tar.gz"
    sha256 "2b3a882ebf27dd026df3801a87cf49ff791336e0f94b0fad195db77e01240690"
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
