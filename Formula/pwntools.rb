class Pwntools < Formula
  include Language::Python::Virtualenv

  desc "CTF framework used by Gallopsled in every CTF"
  homepage "https://pwntools.com/"
  url "https://github.com/Gallopsled/pwntools/archive/3.4.1.tar.gz"
  sha256 "54e741557609af73c1817ff9f5a4087390ba9cb0f1b11264ab5bbf225e326bec"

  bottle do
    cellar :any
    sha256 "c6011425f8fd06ef08f33d812b1e9797e84bbdf1973d335cc48cfdf337a38f14" => :sierra
    sha256 "0d1ad26e43912dfa1a95f95082f648b91e66a00ef093bf4e1d635da8fa2f1535" => :el_capitan
    sha256 "6a12a0e5fbe7e9cd70fba75502d6d76f94dedbff27394526b250fba3b08c843c" => :yosemite
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
