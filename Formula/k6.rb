class K6 < Formula
  desc "Modern load testing tool, using Go and JavaScript"
  homepage "https://k6.io"
  url "https://github.com/loadimpact/k6/archive/v0.34.0.tar.gz"
  sha256 "ea91413b99b0f5d251f04ee64f6b10fe916b89479373efc9f162c33bf6541ea0"
  license "AGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "f6a0d61856b2f6b8a3a0190573fbd047f3595e847a1246aff7e8e47cd539b12e"
    sha256 cellar: :any_skip_relocation, big_sur:       "e373bb0b237cb2433c0e310e6d7e5be26d68aaf025261657bd8d96b23fdb1c6b"
    sha256 cellar: :any_skip_relocation, catalina:      "6667403e67b9d1b8836b2ad18c78754a58cccb0f0f398a1534947864f67e42e1"
    sha256 cellar: :any_skip_relocation, mojave:        "a128952436404d19d8454905e5e8a063814fa1c651c6a3273175e90fe179b77f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ceddee68718b5a878466379557a324b7c43cdf9039e4514e12bc1670752b2efd"
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
