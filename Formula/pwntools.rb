class Pwntools < Formula
  include Language::Python::Virtualenv

  desc "CTF framework used by Gallopsled in every CTF"
  homepage "https://pwntools.com/"
  url "https://github.com/Gallopsled/pwntools/archive/3.3.0.tar.gz"
  sha256 "323775fb33ef289065a39817ff0b53a4e1bf6383723ba9553b7e1c1ef1b8bc24"

  bottle do
    cellar :any
    sha256 "0f8dea021b295baa336e19e5cafb7bd7fcb535610f469f506ff9837050842682" => :sierra
    sha256 "b1ff0dce2aeebf1fbef040b3c111997acc928b79baec97f5a2dd081eadebdcef" => :el_capitan
    sha256 "69ffbf4e70b9a2ef157bcbf7272bbdd0a344acdfb84e150a2f0803959cd9a892" => :yosemite
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
