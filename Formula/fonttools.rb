class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://files.pythonhosted.org/packages/bd/1e/5829f2b579fc0148500776cdf3ea59bc9d6358892cb43df6715d34fa6004/fonttools-4.26.1.zip"
  sha256 "2c7bbbcd5ee4e4d91af1001884c7bd9fb5bd29eac2754a16002f187afa584185"
  license "MIT"
  head "https://github.com/fonttools/fonttools.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "720ce3b06614ada6acbd7f53751b8d5409d85696960e5660aedc66de5fb63d90"
    sha256 cellar: :any_skip_relocation, big_sur:       "b8c387e3216ae6cf3756690b52acf240f4ac4d088f0300f3392aded6c2e733e7"
    sha256 cellar: :any_skip_relocation, catalina:      "b8c387e3216ae6cf3756690b52acf240f4ac4d088f0300f3392aded6c2e733e7"
    sha256 cellar: :any_skip_relocation, mojave:        "b8c387e3216ae6cf3756690b52acf240f4ac4d088f0300f3392aded6c2e733e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b12e4a0b93c421d67451e27f12a5e77126710d751570f1fe3ce9965e3a9ffe1b"
  end

  depends_on "python@3.9"

  def install
    virtualenv_install_with_resources
  end

  test do
    on_macos do
      cp "/System/Library/Fonts/ZapfDingbats.ttf", testpath
      system bin/"ttx", "ZapfDingbats.ttf"
    end
    on_linux do
      assert_match "usage", shell_output("#{bin}/ttx -h")
    end
  end
end
