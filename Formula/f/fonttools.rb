class Fonttools < Formula
  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://files.pythonhosted.org/packages/dd/e5/9adc30ebca9009d5ad36c7e74462ee5fc51985ca9a845fd26f9f5c99b3df/fonttools-4.47.0.tar.gz"
  sha256 "ec13a10715eef0e031858c1c23bfaee6cba02b97558e4a7bfa089dba4a8c2ebf"
  license "MIT"
  head "https://github.com/fonttools/fonttools.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "11cacbe297450df5b4754537fe108c03e196f4313221734b4fd51aeae501d376"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d436d948825dc4b51027c4c85f8475109caf493c97a129f1b4e08570c850a298"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "72c91632b77ac53d0b6c3f65ceb2c39f1e7658433714880b02b18b0db551bd88"
    sha256 cellar: :any_skip_relocation, sonoma:         "2fb3c2da9c598a4d94ddce76cc7fcbca292c77aef199ee513f0a9795c634ab37"
    sha256 cellar: :any_skip_relocation, ventura:        "76da97ba850e987698b8129a4ff4d97a0a51b774613ec17f921d6968ece2d154"
    sha256 cellar: :any_skip_relocation, monterey:       "8f3a6873c275551bf2803962a01300b7b9fce1b28ae18506d2b36b682afdff81"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f397c27cd1250d8a95fb27d874df44a2409e7bcda9531c36f0216ff717b1b4c5"
  end

  depends_on "python-setuptools" => :build
  depends_on "python-brotli"
  depends_on "python@3.12"

  def python3
    which("python3.12")
  end

  def install
    system python3, "-m", "pip", "install", *std_pip_args, "."
  end

  test do
    if OS.mac?
      cp "/System/Library/Fonts/ZapfDingbats.ttf", testpath

      system bin/"ttx", "ZapfDingbats.ttf"
      assert_predicate testpath/"ZapfDingbats.ttx", :exist?
      system bin/"fonttools", "ttLib.woff2", "compress", "ZapfDingbats.ttf"
      assert_predicate testpath/"ZapfDingbats.woff2", :exist?
    else
      assert_match "usage", shell_output("#{bin}/ttx -h")
    end
  end
end
