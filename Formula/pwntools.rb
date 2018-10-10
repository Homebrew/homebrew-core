class Pwntools < Formula
  include Language::Python::Virtualenv

  desc "CTF framework used by Gallopsled in every CTF"
  homepage "https://pwntools.com/"
  url "https://github.com/Gallopsled/pwntools/archive/3.12.0.tar.gz"
  sha256 "e743daa158a3ac1e958b52e61de47f3db6cec701379712eeda4f4a977ca32309"

  bottle do
    cellar :any
    rebuild 1
    sha256 "cbae139d1ee708f9cd64da8c4dec4b085d30c7de631377b71e6ba235081862f0" => :mojave
    sha256 "7f14e0eb3b4432b3f83e9e9ec111ece13074554fc3c2639b1b498bf446ad9955" => :high_sierra
    sha256 "eeb5624205ad19b86908e51e32f8c3cd5faf3c5c75c8e3e29cbcc58597eaf022" => :sierra
  end

  depends_on "binutils"
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
