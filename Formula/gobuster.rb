class Gobuster < Formula
  desc "Directory/file & DNS busting tool written in Go"
  homepage "https://github.com/OJ/gobuster"
  url "https://github.com/OJ/gobuster/archive/refs/tags/v3.2.0.tar.gz"
  sha256 "63094d24b79622d798f1aed2e497c8a6dd2bbeaa4fda7162ec71bc7070bf1a61"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3f687fc8594fc7400f99fcfc8181bc7d020cf59ce38c2a3be7dbaa66c20e52ec"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2b005c501f889745a8da2ed39dda4ff71a603b62e644532589097c6bc81ed1c5"
    sha256 cellar: :any_skip_relocation, monterey:       "dced6c400a6e129c9edeef7b4602a42f4254358edfa129364ce5c9856376ccc5"
    sha256 cellar: :any_skip_relocation, big_sur:        "d1baeae047194d29c3867336f71c562d176a10615bb66e551556616374af43ca"
    sha256 cellar: :any_skip_relocation, catalina:       "36e5a28fecf54ff70810fc2f908a53751c2bdcd06b262183baae9556b294e205"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5e325f0a07ef501aead02d7079e9da4c35e51c297274a1fcf745ea358d5a34b6"
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

    assert_match version.to_s, shell_output(bin/"gobuster version")
  end
end
