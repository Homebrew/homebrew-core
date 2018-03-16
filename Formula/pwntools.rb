class Pwntools < Formula
  include Language::Python::Virtualenv

  desc "CTF framework used by Gallopsled in every CTF"
  homepage "https://pwntools.com/"
  url "https://github.com/Gallopsled/pwntools/archive/3.12.0.tar.gz"
  sha256 "e743daa158a3ac1e958b52e61de47f3db6cec701379712eeda4f4a977ca32309"

  bottle do
    cellar :any
    sha256 "7b5a323a81a6a5cf115298af0fa17da8dd097c73a28e64e687fd6535881949d2" => :high_sierra
    sha256 "f4a156877e9c9f378dff8b2acbd6da6888955dc3ada84dcbfc6bc9605f0d5bb3" => :sierra
    sha256 "d91c5982da9494c2cc4f4eca62ee02dff1b735f836602e62f425f51b5239a89b" => :el_capitan
  end

  depends_on "python@2" if MacOS.version <= :snow_leopard
  depends_on "openssl"
  depends_on "binutils" => :recommended

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
