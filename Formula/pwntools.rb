class Pwntools < Formula
  include Language::Python::Virtualenv

  desc "CTF framework used by Gallopsled in every CTF"
  homepage "https://pwntools.com/"
  url "https://github.com/Gallopsled/pwntools/archive/3.11.0.tar.gz"
  sha256 "b86f9bed835153d1ce1839d03836aa062802ac9f5495942027030407ef1b798a"

  bottle do
    cellar :any
    sha256 "fb1c43b189c0dec59baa9d6622712d5abed9dc0fa9256b22ab2d0e574ad07e2c" => :high_sierra
    sha256 "2067d72a5fad30b5bae3e3648362c38d93954ae59579f4e2c305e21ecaac4713" => :sierra
    sha256 "00fac40376d2d563ee475215717bb288380435e41344d513bc6b45489e9123c2" => :el_capitan
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
