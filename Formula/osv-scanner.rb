class OsvScanner < Formula
  desc "Vulnerability scanner which uses the OSV database"
  homepage "https://github.com/google/osv-scanner"
  url "https://github.com/google/osv-scanner/archive/refs/tags/v1.3.4.tar.gz"
  sha256 "19229149eca937a4da60ca29416fe1ea6997655fd10e273b833082ef5977a3de"
  license "Apache-2.0"
  head "https://github.com/google/osv-scanner.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7f8bd609593d69baa061655bad2c6915f30287b147518c5d0320e3615c98d70b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7f8bd609593d69baa061655bad2c6915f30287b147518c5d0320e3615c98d70b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7f8bd609593d69baa061655bad2c6915f30287b147518c5d0320e3615c98d70b"
    sha256 cellar: :any_skip_relocation, ventura:        "b37ea9fb7ce4c08e8c72cad1eea342c6eb85e0df94f644756b5ed91c5ba1f410"
    sha256 cellar: :any_skip_relocation, monterey:       "b37ea9fb7ce4c08e8c72cad1eea342c6eb85e0df94f644756b5ed91c5ba1f410"
    sha256 cellar: :any_skip_relocation, big_sur:        "b37ea9fb7ce4c08e8c72cad1eea342c6eb85e0df94f644756b5ed91c5ba1f410"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "258487930cb5f24d7b4e40aec197d9f33ba216bd1857bfc4deb32e142550e2c8"
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
    expected_output = <<~EOS.chomp
      Scanned #{testpath}/go.mod file and found 1 packages
      No vulnerabilities found
    EOS
    assert_equal expected_output, scan_output
  end
end
