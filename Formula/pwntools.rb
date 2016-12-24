class Pwntools < Formula
  include Language::Python::Virtualenv

  desc "CTF framework used by Gallopsled in every CTF"
  homepage "https://pwntools.com/"
  url "https://github.com/Gallopsled/pwntools/archive/3.3.0.tar.gz"
  sha256 "323775fb33ef289065a39817ff0b53a4e1bf6383723ba9553b7e1c1ef1b8bc24"

  bottle do
    cellar :any
    sha256 "3e00b3ca5d5d2fe68d254918cbde5297e53832ef27397d86e0c1dc8e8742433f" => :sierra
    sha256 "c7e488abcf265433b6b35a7ad7dd6440b24f343bbd6787ebcc7cdc864ce698aa" => :el_capitan
    sha256 "38979f7d0c0f8e16bc6f21a8a08f9c96ade6a726acebad3cf7c0620248c694c1" => :yosemite
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
