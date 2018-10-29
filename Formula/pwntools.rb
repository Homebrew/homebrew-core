class Pwntools < Formula
  include Language::Python::Virtualenv

  desc "CTF framework used by Gallopsled in every CTF"
  homepage "https://github.com/Gallopsled/pwntools"
  url "https://github.com/Gallopsled/pwntools/archive/3.12.1.tar.gz"
  sha256 "dfea4140d345f2749086e07ed9c08d5625e50e0f969e2894509e69f9d4755c3d"

  bottle do
    cellar :any
    sha256 "92677bd9b28d1dddae37d5bdc617902eccf57c1172c03e3a79ae9299d755015d" => :mojave
    sha256 "2a0422a573677cc55657a696c678db4bda9c79498f9bbbd4b01e542f4105975b" => :high_sierra
    sha256 "3b4d273279f53627c5125be3bbb498d11339502565dc631e5dc6c7fe9badaf4f" => :sierra
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
