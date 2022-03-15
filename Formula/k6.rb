class K6 < Formula
  desc "Modern load testing tool, using Go and JavaScript"
  homepage "https://k6.io"
  url "https://github.com/loadimpact/k6/archive/v0.37.0.tar.gz"
  sha256 "a0bb00caa1eb404b53d6296c81bde917c7ea9b6f50c8c49c1985b95a3dd82002"
  license "AGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c025cda04224dba7165b208e4a93c417bf0c90bad87e01d0098894f062fd2d77"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "55317c6d702d5125a932e27dc2d8026cfac868b306d6c366fc1e7ad924d1434f"
    sha256 cellar: :any_skip_relocation, monterey:       "0aba4f43409f720ba7b0d8ab8f4dc64f4edd5f7a931d9d326d2b6666283944fb"
    sha256 cellar: :any_skip_relocation, big_sur:        "dd0e67cecb0162cf84e04f8391b58bad3176f4175ccf570fb3a49a23a03b4652"
    sha256 cellar: :any_skip_relocation, catalina:       "a5ef359c3f3a3a205b82d1136bf70795e4963e94c88425d6d88aea99d66b2df4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a92cd958ad55c66069c0d783d7e8e94be27beb32cf226593a413b167a34fa992"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    (testpath/"whatever.js").write <<~EOS
      export default function() {
        console.log("whatever");
      }
    EOS

    assert_match "whatever", shell_output("#{bin}/k6 run whatever.js 2>&1")
    assert_match version.to_s, shell_output("#{bin}/k6 version")
  end
end
