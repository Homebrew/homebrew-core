class Phive < Formula
  desc "Phar Installation and Verification Environment (PHIVE)"
  homepage "https://phar.io"
  url "https://github.com/phar-io/phive/releases/download/0.16.0/phive-0.16.0.phar"
  sha256 "1525f25afec4bcdc0aa8db7bb4b0063851332e916698daf90c747461642a42ed"
  license "BSD-3-Clause"

  bottle do
    manifest_sha256 "9f8427c5f6ce84472e80614dde8d318c6b8c82ab7ef89b56ec090603a99015e5"
    sha256 cellar: :any_skip_relocation, all: "67aba197622d728b6cd0ebd19c76de0ac6806aeacc29d46a95d41f00dd63a6f3"
  end

  depends_on "php"

  deny_network_access!

  def install
    bin.install "phive-#{version}.phar" => "phive"
  end

  test do
    assert_match "No PHARs configured for this project", shell_output("#{bin}/phive status")
  end
end
