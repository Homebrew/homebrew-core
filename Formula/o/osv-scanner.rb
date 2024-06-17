class OsvScanner < Formula
  desc "Vulnerability scanner which uses the OSV database"
  homepage "https://github.com/google/osv-scanner"
  url "https://github.com/google/osv-scanner/archive/refs/tags/v1.7.4.tar.gz"
  sha256 "cf1daa47cdab503149d25d03287543866c53b4ab04b3e02ca0e6fc47caf1f696"
  license "Apache-2.0"
  head "https://github.com/google/osv-scanner.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d10f3091e149c905e01ee9d04f2e6111fbaee075a9e7317583d1139f25f39e81"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5386a80dff6a6022576f628a6a900d88d96bebf566db60e87851751a1bfc4a5f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "40e90b0b6a57fa7ccc1aaa23ff902b2ae77f69c7f66c075a564f40c1d5c2fbed"
    sha256 cellar: :any_skip_relocation, sonoma:         "64033f3cf53ec9677c3951fd902df450586e261a57eb0f2ffb611790dcdde1ab"
    sha256 cellar: :any_skip_relocation, ventura:        "6e9d23a293b106882a27044b5fb5356a46b7636c1872f84ad7b8111532d89766"
    sha256 cellar: :any_skip_relocation, monterey:       "aadb0c42f48ee398b875eda5d11cc221d430842506f3bee955e0783b2d87df92"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eac509258f18feb2d51d8812e9e430773b4a461f190072de39071ca676bda510"
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
