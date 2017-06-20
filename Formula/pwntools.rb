class Pwntools < Formula
  include Language::Python::Virtualenv

  desc "CTF framework used by Gallopsled in every CTF"
  homepage "https://pwntools.com/"
  url "https://github.com/Gallopsled/pwntools/archive/3.7.0.tar.gz"
  sha256 "ebbe14a334de1d8f9c3ac7500d35f81a06b1d7d8d920ce79647340f159959f6d"

  bottle do
    cellar :any
    sha256 "48d1955b02028eb977a8e45dcc4c54696e6b0b69dfc9c9a05dea6b5a95af2b7a" => :sierra
    sha256 "7ffdeb8a5dd050583a9eaea7895d20511f8fc3124d77c29676e99fe1c57a9416" => :el_capitan
    sha256 "a5b2b9ca618e6dd9844b3f913c9127fff2d02604c3694d4ec184bd0fec0bf3c4" => :yosemite
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
