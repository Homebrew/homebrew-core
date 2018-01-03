class Pwntools < Formula
  include Language::Python::Virtualenv

  desc "CTF framework used by Gallopsled in every CTF"
  homepage "https://pwntools.com/"
  url "https://github.com/Gallopsled/pwntools/archive/3.11.0.tar.gz"
  sha256 "b86f9bed835153d1ce1839d03836aa062802ac9f5495942027030407ef1b798a"

  bottle do
    cellar :any
    sha256 "f732c5be40a637ce5514994eade6bb3e4d2ed91b8ff4043153a8ceb3463742de" => :high_sierra
    sha256 "744c5ec54d78c0b1ac62d800b31dcdaa2090361d654e51d368d4eea1cefbaa69" => :sierra
    sha256 "09315168fe27379542d8cddc28776bb7f188fccdb9759b8e87be0699c1b218a1" => :el_capitan
  end

  depends_on "python" if MacOS.version <= :snow_leopard
  depends_on "openssl@1.1"
  depends_on "binutils" => :recommended

  conflicts_with "moreutils", :because => "Both install `errno` binaries"

  def install
    venv = virtualenv_create(libexec)
    system libexec/"bin/pip", "install", "-v", "--no-binary", ":all:",
                              "--ignore-installed", buildpath
    system libexec/"bin/pip", "uninstall", "-y", name
    venv.pip_install_and_link buildpath
  end

  test do
    assert_equal "686f6d6562726577696e7374616c6c636f6d706c657465",
                 shell_output("#{bin}/hex homebrewinstallcomplete").strip
  end
end
