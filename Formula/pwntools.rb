class Pwntools < Formula
  include Language::Python::Virtualenv

  desc "CTF framework used by Gallopsled in every CTF"
  homepage "https://pwntools.com/"
  url "https://github.com/Gallopsled/pwntools/archive/3.11.0.tar.gz"
  sha256 "b86f9bed835153d1ce1839d03836aa062802ac9f5495942027030407ef1b798a"
  revision 1

  bottle do
    cellar :any
    sha256 "01057bf1e5efdfd55e313e75cc5d33c5e3ad7fe692dd4b79afa6ddcd7793e9c7" => :high_sierra
    sha256 "d615dd3a1af8ebff94643de496985db4582b0ce9732f78b931232a1b884fd87c" => :sierra
    sha256 "455b41e64f7be98cb4b0dadbac8d57dcc0d7c28dae7bb6b84decfc641b23283e" => :el_capitan
  end

  depends_on "python" if MacOS.version <= :snow_leopard
  depends_on "openssl"
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
