class Katana < Formula
  desc "Crawling and spidering framework"
  homepage "https://github.com/projectdiscovery/katana"
  url "https://github.com/projectdiscovery/katana/archive/refs/tags/v1.0.3.tar.gz"
  sha256 "404a3c4cb073c9a30835c5b7e8eed091dd6472e572e231a21959e3971fdc7bc0"
  license "MIT"
  head "https://github.com/projectdiscovery/katana.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bf55454a5b1a7a40503af162371300949381cb46e101e1c5fe6a4014695e0127"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6aba68e58b449f3045d7d4599f25ba06bd3943683c1104311575f3925e590aed"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3238ce24043114a44140cafeb4f8b8b7ea268aa7d82fe32796848004ef452891"
    sha256 cellar: :any_skip_relocation, ventura:        "40a2dd013608deb55b43459fa5aac052c4999aef71189133cabd1ffb9d6499d5"
    sha256 cellar: :any_skip_relocation, monterey:       "839101b09f0e925673213eb3fa3d3fb065885c0173accb6d0ae80403edc1fa94"
    sha256 cellar: :any_skip_relocation, big_sur:        "0332866800b70fecd8f7b2c93c0fcef4c4634c3d60fecc80948eb5f0e5f3512d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4086b4f990015892326f8ef372b098a53bc16ea44aa93ddf17b1229d6b465b69"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/katana"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/katana -version 2>&1")
    assert_match "Started standard crawling", shell_output("#{bin}/katana -u 127.0.0.1 2>&1")
  end
end
