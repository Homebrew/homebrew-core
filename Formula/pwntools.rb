class Pwntools < Formula
  include Language::Python::Virtualenv

  desc "CTF framework used by Gallopsled in every CTF"
  homepage "https://pwntools.com/"
  url "https://github.com/Gallopsled/pwntools/archive/3.6.1.tar.gz"
  sha256 "ac55777449a93d6a691c9f2230020c93961228aa9857a1e5fd4b3d3cf1073b13"

  bottle do
    cellar :any
    sha256 "d27cc2693811f5a31898d0f656fabc5f52af117473fea5ac3a04f021f05898b6" => :sierra
    sha256 "e09e200a78a56206391b94060ce1416e31bc884994de13650bf64bbf0f6edd1e" => :el_capitan
    sha256 "02e5092ca366c6cdd7a8f666fc1196439c45c191405acd00704383fce4c731a1" => :yosemite
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
