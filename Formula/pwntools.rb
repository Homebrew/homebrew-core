class Pwntools < Formula
  include Language::Python::Virtualenv

  desc "CTF framework used by Gallopsled in every CTF"
  homepage "https://github.com/Gallopsled/pwntools"
  url "https://github.com/Gallopsled/pwntools/archive/3.12.2.tar.gz"
  sha256 "8e048b514ee449b4c76f4eba1b4fcd48fdefd1bf04ae4c62b44e984923d2e979"
  revision 1

  bottle do
    cellar :any
    sha256 "258e2df2d025801d2173307b68639b968f0293d3d5f9acb8c7a884e5cd639768" => :mojave
    sha256 "3a6fa84fbdd9683af6b5800fd4fa14e8369419f3a8abc9b5e8bd23bde447c3a5" => :high_sierra
    sha256 "60d76ec99a2646e6ea82e226aff196f45af7d209c36ed848cc29dea52b5e1c54" => :sierra
  end

  depends_on "openssl@1.1"
  depends_on "python@2" # does not support Python 3

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
