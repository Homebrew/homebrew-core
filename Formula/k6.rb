class K6 < Formula
  desc "Modern load testing tool, using Go and JavaScript"
  homepage "https://k6.io"
  url "https://github.com/loadimpact/k6/archive/v0.38.1.tar.gz"
  sha256 "d48dc59008cdd565c8362b064889770da11069f75719aa001aeab7dd92f4a1b5"
  license "AGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "49e760112a8b6f39acccbdde473ea751d0a15aacbcad20b7d69adec16ffda243"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5403669df36bc74c192892c71597d0282794ac47440ca41374c43475a80d3673"
    sha256 cellar: :any_skip_relocation, monterey:       "77d440712399ab2e6a9be6e206b3edb10a0199dad3e292e7dd3325794f0ed602"
    sha256 cellar: :any_skip_relocation, big_sur:        "248cc856fd5f7e17f6485666b8ae00ac866622e11f23c781a67ffd6f547b4588"
    sha256 cellar: :any_skip_relocation, catalina:       "5bc822e865c63be622e13116b081cf57b8fa8d3b934492c74e4828bd747e5c9c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b1ec621c69fadd6a46b3053798e7326a7fdb45835e9d5db060689a78f256908c"
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
