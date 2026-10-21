class Mpremote < Formula
  include Language::Python::Virtualenv

  desc "Tool for interacting remotely with MicroPython devices"
  homepage "https://docs.micropython.org/en/latest/reference/mpremote.html"
  url "https://files.pythonhosted.org/packages/ac/b7/8c44eb606b0e53517fd6ddda3f598b3bdb180c181f4e0bcbb9b7743f4cb5/mpremote-1.29.0.tar.gz"
  sha256 "ab0b6f21059698e573ca076fe9a0299e5fe7bbc3ca3f5b2f00007e22e51c7b80"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "473071f1fc70e954d08258b295f52826843cbdafed173d79bc4c3d269d0a2491"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "473071f1fc70e954d08258b295f52826843cbdafed173d79bc4c3d269d0a2491"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "473071f1fc70e954d08258b295f52826843cbdafed173d79bc4c3d269d0a2491"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "ad6d2c1b14903730c6aa412b5e27732c08b265d4ac39b6d7761719e6966df255"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "ad6d2c1b14903730c6aa412b5e27732c08b265d4ac39b6d7761719e6966df255"
  end

  depends_on "python@3.15"

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/90/a1/d5f9002a70298c64a789779077d8dd90c10aa1f47fe40c86802df874f2a6/platformdirs-4.12.4.tar.gz"
    sha256 "63743c02414e755de4e31b8f68125c1407495b86c5a006e203c01ff8b9924250"
  end

  resource "pyserial" do
    url "https://files.pythonhosted.org/packages/1e/7d/ae3f0a63f41e4d2f6cb66a5b57197850f919f59e558159a4dd3a818f5082/pyserial-3.5.tar.gz"
    sha256 "3c77e014170dfffbd816e6ffc205e9842efb10be9f58ec16d3e8675b4925cddb"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mpremote --version")
    assert_match "no device found", shell_output("#{bin}/mpremote soft-reset 2>&1", 1)
  end
end
