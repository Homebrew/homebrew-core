class Pwntools < Formula
  include Language::Python::Virtualenv

  desc "CTF framework used by Gallopsled in every CTF"
  homepage "https://pwntools.com/"
  url "https://github.com/Gallopsled/pwntools/archive/3.5.0.tar.gz"
  sha256 "901a65ddad6130ee172823736bd6211938d8a089e8985372c538bb91476361f0"

  bottle do
    cellar :any
    sha256 "1b3f85b2b9b9df2580e682834bf5212f71851ca2ce186f4b3a8c11631cbc3f6f" => :sierra
    sha256 "8a6135d0dcfd994e87fb7fa862e1b081916345d7c5b3fcaebcc794f3d001b03d" => :el_capitan
    sha256 "45fcd4005b494018548351e882a1fe651ed35eabd5f0e5ee4db1f563016cabc2" => :yosemite
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
