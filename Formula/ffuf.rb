class Ffuf < Formula
  desc "Fast web fuzzer written in Go"
  homepage "https://github.com/ffuf/ffuf"
  url "https://github.com/ffuf/ffuf/archive/refs/tags/v2.0.0.tar.gz"
  sha256 "80b42fe3dda8b24e10bade7b18651d402d1acf5031baedd0b344985721f3d8cd"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "aa038dc103b94561af5910373583ba6f1dd5ae23d58864925a22d178abd16d6d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2ea1e225d90b5a71bc8df9f8360ca6dd161ffc74dd797721159ce204cc2295d4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1a034d074039f546efa26aaf282ee808462a4ea9c0ca5dece61a6ebd86dad65b"
    sha256 cellar: :any_skip_relocation, ventura:        "c726eab7aa1546a9ed12742d39f4da2fa0d886ad16f8e8aa4bf42295c1085dbd"
    sha256 cellar: :any_skip_relocation, monterey:       "3227a502ebf3df5baa0e3f16f20b2b922b9de194e12b01638bca62507d4a310f"
    sha256 cellar: :any_skip_relocation, big_sur:        "1af1d61f76a3c22dbb5f16f2ab2bc8f4eb18868b299c39b1606f3d1157da24b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "96d9dfc85808a0d58ae0f1ef18f2f05ec31441b4c04edea00702435bfbc94cd3"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    (testpath/"words.txt").write <<~EOS
      dog
      cat
      horse
      snake
      ape
    EOS

    output = shell_output("#{bin}/ffuf -u https://example.org/FUZZ -w words.txt 2>&1")
    assert_match %r{:: Progress: \[5/5\].*Errors: 0 ::$}, output
  end
end
