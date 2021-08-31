class Pgxnclient < Formula
  include Language::Python::Virtualenv

  desc "Command-line client for the PostgreSQL Extension Network"
  homepage "https://pgxn.github.io/pgxnclient/"
  url "https://github.com/pgxn/pgxnclient/archive/refs/tags/v1.3.2.tar.gz"
  sha256 "0d02a91364346811ce4dbbfc2f543356dac559e4222a3131018c6570d32e592a"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "7422462c36584a0622698d37693d37fcba3d3fdabbbf184fe3cb5930a1a041b6"
    sha256 cellar: :any_skip_relocation, big_sur:       "90daeaa33dc73e7a0c9694ecf93f24d13ea7fb182590d2ad5c60969ad0f1281a"
    sha256 cellar: :any_skip_relocation, catalina:      "eeb6087b532a991ee65bfc78c83d06463be1150c8330d9c0f2c593cbd961a205"
    sha256 cellar: :any_skip_relocation, mojave:        "1561677627ceb505dc7c5cc15cbefc686a696e574b5dd34a0414ee02fcb0c7ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a2e647eaaf9e8c0d0afc0e6ee62d83ec29151c487f922ef6b3d3abf9959f7e55"
  end

  depends_on "python@3.9"
  depends_on "six"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "pgxn", shell_output("#{bin}/pgxnclient mirror")
  end
end
