class Dsync < Formula
  desc "Database migration and synchronization tool"
  homepage "https://adiom.io"
  url "https://github.com/adiom-data/dsync/archive/refs/tags/v0.23.0.tar.gz"
  sha256 "79103cb24f3936047c43e1b81361fdaf60b8495d21329b9d743c792408596b6c"
  license "AGPL-3.0-or-later"

  depends_on "go" => :build

  def install
    # Standard Homebrew Go build pattern
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    # A simple test to ensure the binary runs
    assert_match "dsync version #{version}", shell_output("#{bin}/dsync --version")
    # Optional: Test a basic help command
    assert_match(/Usage:/i, shell_output("#{bin}/dsync --help"))
  end
end
