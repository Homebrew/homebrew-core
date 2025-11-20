class Croc < Formula
  desc "Securely send things from one computer to another"
  homepage "https://github.com/schollz/croc"
  url "https://github.com/schollz/croc/archive/refs/tags/v10.3.1.tar.gz"
  sha256 "098f9f7295843b09378dd49877ef189aaafac8e6255a346a5f1f9ce310538312"
  license "MIT"
  head "https://github.com/schollz/croc.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "70b294293f8edad21247f82fd62bf51d8b7cf10ea7f14769fec40b00e067f8d9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "70b294293f8edad21247f82fd62bf51d8b7cf10ea7f14769fec40b00e067f8d9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "70b294293f8edad21247f82fd62bf51d8b7cf10ea7f14769fec40b00e067f8d9"
    sha256 cellar: :any_skip_relocation, sonoma:        "bcbf9ff98f79ec2fc5bf45c800b613c30c76a71e9c11ecaf5ec44662f87d7647"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a1b845ba0cafb27adc4769b6865c94500a25e06afda93cb67643736d6a141571"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "96b673c773107e3a8fb3fe7542140293ea1c219437e29994dfc80907a693e634"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    # As of https://github.com/schollz/croc/pull/701 an alternate method is used to provide the secret code
    ENV["CROC_SECRET"] = "homebrew-test"

    port=free_port

    fork do
      exec bin/"croc", "relay", "--ports=#{port}"
    end
    sleep 3

    fork do
      exec bin/"croc", "--relay=localhost:#{port}", "send", "--code=homebrew-test", "--text=mytext"
    end
    sleep 3

    assert_match shell_output("#{bin}/croc --relay=localhost:#{port} --overwrite --yes homebrew-test").chomp, "mytext"
  end
end
