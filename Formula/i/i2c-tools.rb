class I2cTools < Formula
  desc "Heterogeneous set of I2C tools for Linux"
  homepage "https://i2c.wiki.kernel.org/index.php/I2C_Tools"
  url "https://mirrors.edge.kernel.org/pub/software/utils/i2c-tools/i2c-tools-4.4.tar.xz"
  sha256 "8b15f0a880ab87280c40cfd7235cfff28134bf14d5646c07518b1ff6642a2473"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.1-or-later"]

  livecheck do
    url "https://mirrors.edge.kernel.org/pub/software/utils/i2c-tools/"
    regex(/href=.*?i2c-tools[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_linux:  "dd2a87e8ac0da6a882e8e0c117b93ea8e8932629703e372b39f6f92bf93387b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "d20107422ff757ff511d2a8099bb04f96cba86e4a0a81081efe7a7c49d02b118"
  end

  depends_on "python@3.13" => [:build, :test]
  depends_on :linux

  def python3
    "python3.13"
  end

  def install
    system "make", "install", "PREFIX=#{prefix}", "EXTRA=eeprog"
    system python3, "-m", "pip", "install", *std_pip_args(build_isolation: true), "./py-smbus"
  end

  test do
    system python3, "-c", "import smbus"
    assert_empty shell_output("#{sbin}/i2cdetect -l 2>&1").strip
    assert_match "/dev/i2c/0': No such file or directory", shell_output("#{sbin}/i2cget -y 0 0x08 2>&1", 1)
    assert_match "No EEPROM found", shell_output("#{bin}/decode-dimms 2>&1")
  end
end
