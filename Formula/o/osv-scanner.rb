class OsvScanner < Formula
  desc "Vulnerability scanner which uses the OSV database"
  homepage "https://github.com/google/osv-scanner"
  url "https://github.com/google/osv-scanner/archive/refs/tags/v1.9.0.tar.gz"
  sha256 "85ce158b6dce22cddc19b652bdc5150145b57119e3acfa8e3ae5ba1cfa449a3f"
  license "Apache-2.0"
  head "https://github.com/google/osv-scanner.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "44debfecc1d07ec7412892d1de98afaa6ff1e65faeccf8a32147dcf2628cfbfd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "44debfecc1d07ec7412892d1de98afaa6ff1e65faeccf8a32147dcf2628cfbfd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "44debfecc1d07ec7412892d1de98afaa6ff1e65faeccf8a32147dcf2628cfbfd"
    sha256 cellar: :any_skip_relocation, sonoma:        "263f7107e9720cab76d69a89c72625e02d9a0d9e1c66f44491ca4fe7221a79e6"
    sha256 cellar: :any_skip_relocation, ventura:       "263f7107e9720cab76d69a89c72625e02d9a0d9e1c66f44491ca4fe7221a79e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "55235adac49ec4b0d247524221bdf9160235c873d26d32f1258f9dc605229f3e"
  end

  depends_on "go" => [:build, :test]

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
      Scanned #{testpath}/go.mod file and found 1 package
      No issues found
    EOS
    assert_equal expected_output, scan_output
  end
end
