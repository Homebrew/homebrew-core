
class Duviz < Formula
  include Language::Python::Virtualenv

  desc "Command-line disk space usage visualization utility"
  homepage "https://github.com/soxofaan/duviz"
  url "https://github.com/soxofaan/duviz/archive/1.1.0.tar.gz"
  sha256 "72ecd1ffc5bcc0900bd2b5c5708cf1eb6de2c1ba512b1dfb80a802e9754dea32"

  depends_on "python" if MacOS.version <= :snow_leopard

  def install
    virtualenv_install_with_resources
  end

  test do
    mkdir "work"
    (testpath/"work/helloworld.txt").write("hello world")
    assert_equal "__________\n[  work  ]\n[___2____]", shell_output("#{bin}/duviz --no-progress -i --width=10 work").chomp
  end
end
