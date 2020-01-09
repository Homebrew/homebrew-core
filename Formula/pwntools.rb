class Pwntools < Formula
  include Language::Python::Virtualenv

  desc "CTF framework used by Gallopsled in every CTF"
  homepage "https://github.com/Gallopsled/pwntools"
  url "https://github.com/Gallopsled/pwntools/archive/3.13.0.tar.gz"
  sha256 "36bb37e213046cd265b11ef82c4df1e009f547ecd1ffcbd4720f410b3f71aaf8"

  bottle do
    cellar :any
    sha256 "4451b3af23f57558456b208bafeb26c3edbd37dfe11d4de9d4a815233822759e" => :catalina
    sha256 "c2fdfe2c99004b7800ff8d0768b7804f17b30b81b544864b2735b33a4308b741" => :mojave
    sha256 "17c21c2430aa0e95baccc3f0d25a202682c8133daf61e032da6668506ee79561" => :high_sierra
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
