class Pwntools < Formula
  include Language::Python::Virtualenv

  desc "CTF framework used by Gallopsled in every CTF"
  homepage "https://github.com/Gallopsled/pwntools"
  url "https://github.com/Gallopsled/pwntools/archive/3.13.0.tar.gz"
  sha256 "36bb37e213046cd265b11ef82c4df1e009f547ecd1ffcbd4720f410b3f71aaf8"

  bottle do
    cellar :any
    sha256 "f0102d596ed9aa3247e38c0f0c5e3c110a2c0a742d3d2c85b4386c215724fc7a" => :catalina
    sha256 "e815e89ba708e975275b36a48b6d353ab446e54ee405ac0bea90d5789b4e829e" => :mojave
    sha256 "3aae80b957393eba426ca3c3d164fca42b25919e788f28b8cbd4f2411fbbf3d8" => :high_sierra
  end

  depends_on "openssl@1.1"
  # Has a 4.0 beta release with Python 3 support
  uses_from_macos "python@2"

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
