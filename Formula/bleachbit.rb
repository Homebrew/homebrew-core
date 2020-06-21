class Bleachbit < Formula
  include Language::Python::Virtualenv

  desc "Antiforensics and privacy system disk cleaner"
  homepage "https://www.bleachbit.org"
  url "https://github.com/bleachbit/bleachbit/archive/v4.0.0.tar.gz"
  sha256 "5f7813b1ecda32647b1a31564b66f369fbd0d50d67924f256a0d414abc07501b"

  depends_on "pygobject3"
  depends_on "python@3.8"

  def install
    venv = virtualenv_create(libexec, "python3")
    system "python3", "setup.py", "install", "--prefix=#{prefix}",
                      "--single-version-externally-managed",
                      "--record=installed.txt"
    (libexec/"bin").install "bleachbit.py"
    (bin/"bleachbit").write_env_script libexec/"bin/bleachbit.py",
      :PYTHONPATH => libexec/"lib/python3.8/site-packages"
    venv.pip_install_and_link buildpath
  end

  test do
    assert_match "BleachBit version ", shell_output("#{bin}/bleachbit --sysinfo")
  end
end
