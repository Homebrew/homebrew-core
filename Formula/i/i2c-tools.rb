class I2cTools < Formula
  desc "Heterogeneous set of I2C tools for Linux"
  homepage "https://i2c.wiki.kernel.org/index.php/I2C_Tools"
  url "https://mirrors.edge.kernel.org/pub/software/utils/i2c-tools/i2c-tools-4.4.tar.xz"
  sha256 "8b15f0a880ab87280c40cfd7235cfff28134bf14d5646c07518b1ff6642a2473"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.1-or-later"]
  compatibility_version 1

  livecheck do
    url "https://mirrors.edge.kernel.org/pub/software/utils/i2c-tools/"
    regex(/href=.*?i2c-tools[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 2
    sha256 cellar: :any, arm64_linux:  "6228c8359cabac82da31be8281bbf7c7b76d398db2917ca9790c466ff9da1664"
    sha256 cellar: :any, x86_64_linux: "0fcc4db1a850c7f7d37e941b6a5de063a3d2bdb5e344aeedcc36d5f768389ab0"
  end

  depends_on "python@3.15" => [:build, :test]
  depends_on :linux

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
