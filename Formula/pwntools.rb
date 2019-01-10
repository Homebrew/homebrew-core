class Pwntools < Formula
  include Language::Python::Virtualenv

  desc "CTF framework used by Gallopsled in every CTF"
  homepage "https://github.com/Gallopsled/pwntools"
  url "https://github.com/Gallopsled/pwntools/archive/3.12.2.tar.gz"
  sha256 "8e048b514ee449b4c76f4eba1b4fcd48fdefd1bf04ae4c62b44e984923d2e979"

  bottle do
    cellar :any
    rebuild 1
    sha256 "6c7c1dafcec78ddf24109f89afba154bb459217c8d9759a7277c2903b80fc6cf" => :mojave
    sha256 "48e83940f7b360d563c42ec38fa80584f24acbd6264bd02b9dd0bf28d98a1466" => :high_sierra
    sha256 "bba26510ada47ee822ad552d0b0b4febfbb0f5435af53302c50f8655f85093cf" => :sierra
  end

  depends_on "openssl"
  depends_on "python@2" # does not support Python 3

  if Tab.for_name("moreutils").with?("errno")
    conflicts_with "moreutils", :because => "Both install `errno` binaries"
  end

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
