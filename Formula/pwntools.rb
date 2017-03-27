class Pwntools < Formula
  include Language::Python::Virtualenv

  desc "CTF framework used by Gallopsled in every CTF"
  homepage "https://pwntools.com/"
  url "https://github.com/Gallopsled/pwntools/archive/3.5.0.tar.gz"
  sha256 "901a65ddad6130ee172823736bd6211938d8a089e8985372c538bb91476361f0"

  bottle do
    cellar :any
    sha256 "3c73e8fca074aadb0d8e899b991245e7e994a6ae82263bdf7a3fd4820fe1d146" => :sierra
    sha256 "22a80ea0255133bafdbbf9a52f0e55f595c14b899f18d3463d3cd048b08874ef" => :el_capitan
    sha256 "b7bf28ebbaab20f72ed2ff2fce2076e78175b3628504594c16caff6cb13a9854" => :yosemite
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
