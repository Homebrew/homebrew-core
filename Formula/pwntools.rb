class Pwntools < Formula
  include Language::Python::Virtualenv

  desc "CTF framework used by Gallopsled in every CTF"
  homepage "https://pwntools.com/"
  url "https://github.com/Gallopsled/pwntools/archive/3.9.0.tar.gz"
  sha256 "bc62c6ae0ac0e9ea14e660b4a603355a53ca3134c1ab90b654e618eb2be6df5b"

  bottle do
    cellar :any
    sha256 "5a7c4530835b73b421c3c44094b392823c8b8c72c2bf4cdd695eb73b00a1c39a" => :sierra
    sha256 "3f5f650edf8b6339d770bdb277889ef3f17ef592e4386737abf76184bf149eff" => :el_capitan
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
