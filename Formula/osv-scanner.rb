class OsvScanner < Formula
  desc "Vulnerability scanner which uses the OSV database"
  homepage "https://github.com/google/osv-scanner"
  url "https://github.com/google/osv-scanner/archive/refs/tags/v1.3.1.tar.gz"
  sha256 "1e0b66a6130f3311107ffe4796cc0cf48c276e1c09423f676dc8bc31a96d69b0"
  license "Apache-2.0"
  head "https://github.com/google/osv-scanner.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cce215c44d42f456eaeafab156bb53f610b0b52731b15cda700d430c791cd5fc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "888f061cefd51a004fd90ebcc10b7db3257a8f7f600cc3904e3759fa5f38448f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b4549fc13c32e3c45a9ad97102e6e68cb558f92c16932701ce8295baa4a38944"
    sha256 cellar: :any_skip_relocation, ventura:        "dbdd532ee008ceee501be649681ec7e3ff1e938136f9c0fce3e9931d39bfafb8"
    sha256 cellar: :any_skip_relocation, monterey:       "1bf81272ec9f6285ff6a25f1b935d3693e0c7c5394a81146d6e2a63119f6981c"
    sha256 cellar: :any_skip_relocation, big_sur:        "1149bc65853faa3b08b6973a114a9d73e78a305ace12f7bb7bb731025ccdee17"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0f984a1197f8555039563b82aab6b6ef6b092b83a3ff0959955bd22410381b46"
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
