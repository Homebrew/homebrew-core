class Pwntools < Formula
  include Language::Python::Virtualenv

  desc "CTF framework used by Gallopsled in every CTF"
  homepage "https://pwntools.com/"
  url "https://github.com/Gallopsled/pwntools/archive/3.6.1.tar.gz"
  sha256 "ac55777449a93d6a691c9f2230020c93961228aa9857a1e5fd4b3d3cf1073b13"

  bottle do
    cellar :any
    sha256 "2303e7900dbd0964ef3b63cafa430ba0b0b02ce5039e857e650804333f40682b" => :sierra
    sha256 "88f43faf56c4bc42b2c504e81fdd527c1bb19f3caab3f3625f8503275123c625" => :el_capitan
    sha256 "7513491b7df65c68f6e561c49aaebe75f5db6e57820d5fa51cefc2ad19b66cc5" => :yosemite
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
