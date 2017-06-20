class Pwntools < Formula
  include Language::Python::Virtualenv

  desc "CTF framework used by Gallopsled in every CTF"
  homepage "https://pwntools.com/"
  url "https://github.com/Gallopsled/pwntools/archive/3.7.0.tar.gz"
  sha256 "ebbe14a334de1d8f9c3ac7500d35f81a06b1d7d8d920ce79647340f159959f6d"

  bottle do
    cellar :any
    rebuild 1
    sha256 "0eebee6707ff2d7a5267e8c60b38e372b1abe37654df2f8a0ea70aa3ec389afe" => :sierra
    sha256 "e5e31af9d1470a575ad509a9c51d72aa1367fafcdd289c5ed2fe18bc55974db5" => :el_capitan
    sha256 "36d76e0e6a9a1ffc21576cf2fdcd7ce49ec4f12a2ec4b5c9361646806e77c976" => :yosemite
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
