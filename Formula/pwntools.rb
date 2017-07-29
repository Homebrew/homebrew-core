class Pwntools < Formula
  include Language::Python::Virtualenv

  desc "CTF framework used by Gallopsled in every CTF"
  homepage "https://pwntools.com/"
  url "https://github.com/Gallopsled/pwntools/archive/3.8.0.tar.gz"
  sha256 "2abf4cc6b77928411c515f7b221d1414ed06b321d240f958c399e7638bc4998e"

  bottle do
    cellar :any
    sha256 "85aba802520765a7fcb83fe9fc20fa5a187e6ca530c2cf7f285998899d203cea" => :sierra
    sha256 "724e41ec616e9207769c2ea92aa9e9089fad670a82e6d6e949c93acff7aa51c1" => :el_capitan
    sha256 "c3b34494c255c2f188d9e94a18d1f80a94c12eb814ce8f734f7eeaab20c32eb8" => :yosemite
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
