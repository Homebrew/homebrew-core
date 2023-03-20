class OsvScanner < Formula
  desc "Vulnerability scanner which uses the OSV database"
  homepage "https://github.com/google/osv-scanner"
  url "https://github.com/google/osv-scanner/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "c096df268d7d187eb54ae440fdb3baea534adcb3563c823c35a46d06f3ace029"
  license "Apache-2.0"
  head "https://github.com/google/osv-scanner.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "175075c15327f1d6037972d14d7f8aa6ccbd508cae9c5a9b2849385d780ea314"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0759f49fc64e88d2939f5c14c5024c20c265f1dcd3e13ff552419b4a3fe62bc9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1548c44bcd55fcf82a2df4d4d88a20e0f67a928248a59c8a44482e568b20aed5"
    sha256 cellar: :any_skip_relocation, ventura:        "a2139ddeff4c206f611a13548d32635d468159a912df08c04d8fd542fe95fbad"
    sha256 cellar: :any_skip_relocation, monterey:       "5b7497f6bba1a9f9f931d93e06dcca230854e65fdaf6f02c0008269234224ff5"
    sha256 cellar: :any_skip_relocation, big_sur:        "4e638c4f2880c3458fb9b038e97cba0297dde3fa79310d2c48692267a5861196"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f141d30fd9a18e3d006c157ca31a40d7f665ae22dde413c1c13089bb83f07cca"
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
