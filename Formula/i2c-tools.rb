class I2cTools < Formula
  desc "Heterogeneous set of I2C tools for Linux"
  homepage "https://i2c.wiki.kernel.org/index.php/I2C_Tools"
  url "https://mirrors.edge.kernel.org/pub/software/utils/i2c-tools/i2c-tools-4.3.tar.xz"
  sha256 "1f899e43603184fac32f34d72498fc737952dbc9c97a8dd9467fadfdf4600cf9"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.1-or-later"]
  revision 1

  livecheck do
    url "https://mirrors.edge.kernel.org/pub/software/utils/i2c-tools/"
    regex(/href=.*?i2c-tools[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "e2c612b1dec5fdb5204ca91afd7a475623924ba85bbd8e9894910bfb2b24b083"
  end

  depends_on "python@3.10" => [:build, :test]
  depends_on :linux

  def install
    system "make", "install", "PREFIX=#{prefix}", "EXTRA=eeprog"
    cd "py-smbus" do
      system "python3", *Language::Python.setup_install_args(prefix)
    end
  end

  test do
    system Formula["python@3.10"].opt_bin/"python3", "-c", "import smbus"
    assert_empty shell_output("#{sbin}/i2cdetect -l 2>&1").strip
    assert_match "/dev/i2c/0': No such file or directory", shell_output("#{sbin}/i2cget -y 0 0x08 2>&1", 1)
    assert_match "No EEPROM found", shell_output("#{bin}/decode-dimms 2>&1")
  end
end
