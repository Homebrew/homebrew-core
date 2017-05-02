class Pwntools < Formula
  include Language::Python::Virtualenv

  desc "CTF framework used by Gallopsled in every CTF"
  homepage "https://pwntools.com/"
  url "https://github.com/Gallopsled/pwntools/archive/3.5.1.tar.gz"
  sha256 "2b972c956838e9397ad8e3db6f923a595130739d09be907a127e52b051b9cbf6"

  bottle do
    cellar :any
    sha256 "109705d0a92e13fc733190a63d1a90bd97475aa7b54ce629cd807f26c2e53556" => :sierra
    sha256 "07b4f07e15b7c7360b43bf2ac14b6a5c1074decdbfdc65f11012f9ca02f6b59c" => :el_capitan
    sha256 "d99220ef0eb01666bba2e0685080e122c6d997f035cf6ce16a8c4c4f909e4a24" => :yosemite
  end

  depends_on :python if MacOS.version <= :snow_leopard
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
