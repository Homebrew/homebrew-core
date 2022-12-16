class OsvScanner < Formula
  desc "Vulnerability scanner which uses the OSV database"
  homepage "https://github.com/google/osv-scanner"
  url "https://github.com/google/osv-scanner/archive/refs/tags/v1.0.1.tar.gz"
  sha256 "894f2991e9fa8e1fb1a8f8605779826884e11a2d5e3616814549ef873e5598bd"
  license "Apache-2.0"
  head "https://github.com/google/osv-scanner.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7b194d48730d6ce7cdd88d0f1ab8a6978b435c0fc32d91bd704f1aab8c68d32d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d213b2fc89e4d9c0800d2bbd32e3707c8468378138371e8c8bd0dd40b8058fda"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5cce4ad4c4c3c0813358751a15f1e569372ae1e61b1e8ce74bd80e93628aebed"
    sha256 cellar: :any_skip_relocation, ventura:        "e3f4cd660380453693cfda72f588b26c67dbb1843d29ef05b7f028d9f6ac9abf"
    sha256 cellar: :any_skip_relocation, monterey:       "0172e5bc5726773891e73af19ecb56f8aa542fcd7cd9f3776075d7db2d2b3da1"
    sha256 cellar: :any_skip_relocation, big_sur:        "f683993e84c2b2c998bd250d431304baeb2bcead9fc045a5373a5885af029991"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6090203995f0f17ff7bc7b898c97cd03ca165d9168b12847ec209bbd2519d89a"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/osv-scanner"
  end

  test do
    (testpath/"go.mod").write <<~EOS
      module my-library

      require (
        github.com/BurntSushi/toml v1.0.0
      )
    EOS

    scan_output = shell_output("#{bin}/osv-scanner --lockfile #{testpath}/go.mod").strip
    assert_equal "Scanned #{testpath}/go.mod file and found 1 packages", scan_output
  end
end
