class Gobuster < Formula
  desc "Directory/file & DNS busting tool written in Go"
  homepage "https://github.com/OJ/gobuster"
  url "https://github.com/OJ/gobuster/archive/refs/tags/v3.5.0.tar.gz"
  sha256 "95637b503aa6e96bad2e864e39b51d8f616dff87e54932e0d1af6af514c46e21"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "39f5143ba65fd0a08bfaa94f8510649bc5443434d9584a6d46f363388318110d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "37542e80bb5de721368142b0b5acd7ff367864726d2da2829ff296f819f3f46e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5e098f079d2035fe8f9b400df45149bfced96ef47d52adca31ff84273bb381ab"
    sha256 cellar: :any_skip_relocation, ventura:        "fb3407f0bdea0660470c86173c617c45b1e1ee75a767f0c0d6faef4e3232faff"
    sha256 cellar: :any_skip_relocation, monterey:       "c473363b8bd234b17b3f2514758bdae6731d12c2660d6a5d5be60357d7538dd5"
    sha256 cellar: :any_skip_relocation, big_sur:        "23c617ae4a4c6a5034d84d12d79a9babb3fdfc79ac61427f5a7b5dd7351be4f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a335f588aad5a03686f3b1621b01e0b69695315b16f0d9480bd1e1937c388967"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"gobuster", "completion")
  end

  test do
    (testpath/"words.txt").write <<~EOS
      dog
      cat
      horse
      snake
      ape
    EOS

    output = shell_output("#{bin}/gobuster dir -u https://buffered.io -w words.txt 2>&1")
    assert_match "Finished", output

    assert_match version.major_minor.to_s, shell_output(bin/"gobuster version")
  end
end
