class Pwntools < Formula
  include Language::Python::Virtualenv

  desc "CTF framework used by Gallopsled in every CTF"
  homepage "https://pwntools.com/"
  url "https://github.com/Gallopsled/pwntools/archive/3.2.0.tar.gz"
  sha256 "6f9bf4377692019785860f7f4001da49b2a33843e627c98a6aa1da55445f1dd3"

  bottle do
    sha256 "eb7ef53fe7a303f9315ad92690bd4a6989ce76de17d6d5a3163e24d9b7ad8f63" => :sierra
    sha256 "30296daed88d76dcefc897105f0925df46a02a9ba22138bafc3f6b29b3349cf0" => :el_capitan
    sha256 "5bc0f2d492c2dd408506277386841c5dad16569460c594c88c799d3659508e08" => :yosemite
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
