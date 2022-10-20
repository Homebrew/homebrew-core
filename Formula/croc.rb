class Croc < Formula
  desc "Securely send things from one computer to another"
  homepage "https://github.com/schollz/croc"
  url "https://github.com/schollz/croc/archive/v9.6.1.tar.gz"
  sha256 "a7f0db2b52e44358beb2782412c955f2d5a63da72832b83de48739b1431cb19c"
  license "MIT"
  head "https://github.com/schollz/croc.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b01eb1a0bb2ec668c78acac37dfc5f3f3c554da3e02ecf3690e2f8d6c45b1a37"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "588831172eb24226929ae597190101cf18aa37ef88a13dc9843298bb46723fbf"
    sha256 cellar: :any_skip_relocation, monterey:       "a4f3a9d0eafba3aa54c26121667a4f6c75ac65c54a1031702c47ff6060d01d35"
    sha256 cellar: :any_skip_relocation, big_sur:        "5287371ab9f325be27dd5203d3744d6f11e8fbabd4a2bed2939fb3c16f8eef18"
    sha256 cellar: :any_skip_relocation, catalina:       "e8db9add1b8790adc7bc9baf99165351037f3a5d43697fb95a4125396122099b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6cec97985a5ecc7760697ad32c72f4dfdde011f25d7a954fdb90abe11bf07777"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    port=free_port

    fork do
      exec bin/"croc", "relay", "--ports=#{port}"
    end
    sleep 1

    fork do
      exec bin/"croc", "--relay=localhost:#{port}", "send", "--code=homebrew-test", "--text=mytext"
    end
    sleep 1

    assert_match shell_output("#{bin}/croc --relay=localhost:#{port} --overwrite --yes homebrew-test").chomp, "mytext"
  end
end
