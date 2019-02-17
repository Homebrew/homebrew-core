class Pwntools < Formula
  include Language::Python::Virtualenv

  desc "CTF framework used by Gallopsled in every CTF"
  homepage "https://github.com/Gallopsled/pwntools"
  url "https://github.com/Gallopsled/pwntools/archive/3.12.2.tar.gz"
  sha256 "8e048b514ee449b4c76f4eba1b4fcd48fdefd1bf04ae4c62b44e984923d2e979"

  bottle do
    cellar :any
    sha256 "d234861d32454d58b82d6c3d8ea20b35baf24538bed05d9d0778894d39bd6405" => :mojave
    sha256 "eac26ad4ddb18db83e848852e09a4559959a1f5ddbc00bb8d6711d8842173ae2" => :high_sierra
    sha256 "91d82535a5683cc31032453f0a7214b1c2ff8580be30286bea2344709b99a8e0" => :sierra
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
