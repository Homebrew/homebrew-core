class Pwntools < Formula
  include Language::Python::Virtualenv

  desc "CTF framework used by Gallopsled in every CTF"
  homepage "https://pwntools.com/"
  url "https://github.com/Gallopsled/pwntools/archive/3.8.0.tar.gz"
  sha256 "2abf4cc6b77928411c515f7b221d1414ed06b321d240f958c399e7638bc4998e"

  bottle do
    cellar :any
    sha256 "163645180ef341af0f3ff25ef42316a76a9779822ba19aa46f6614ad1f5f1d27" => :sierra
    sha256 "e1d12cba69d4aa657b58573cf3bc77f7981da303232ab82a4a028be6aa7f9b94" => :el_capitan
    sha256 "7a009eb8f68cd434d230bd5494dbad9f66a5b283c4799ff43d1dd1f0ab9cf253" => :yosemite
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
