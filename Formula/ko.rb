class Ko < Formula
  desc "Build and deploy Go applications on Kubernetes"
  homepage "https://github.com/google/ko"
  url "https://github.com/google/ko/archive/v0.11.2.tar.gz"
  sha256 "000045afa2eaee9a6af475a41fb60541b39e2e7bfb7b985ff7b1040b6bc2c58c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4442b619909d0215c41d711176747e3f139c9eda96e84352c05eef9f6ccdf6d9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "519094e77db389c470a38088ff4b809bb4f4f1ca1e602f8e338e13e0aa4d3e1d"
    sha256 cellar: :any_skip_relocation, monterey:       "6bb8bac9ce5609325fa60d8dd0bcac795f7ab8b52c5863996c678c41d507a6fb"
    sha256 cellar: :any_skip_relocation, big_sur:        "1a5d2b02e531e66bb52c4de13ba0e2a26bd77e7f92d4c9c9a7df8c85073c2f49"
    sha256 cellar: :any_skip_relocation, catalina:       "40940714e128a18a8cb159f339cbc68bf419ce2292a9de520dfb6ddbe2543b15"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c36705c4dddb90628354bd7da1ddfa19c25c0f0ed926d98320247619cc5e95b6"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/google/ko/pkg/commands.Version=#{version}")

    bash_output = Utils.safe_popen_read(bin/"ko", "completion", "bash")
    (bash_completion/"ko").write bash_output

    zsh_output = Utils.safe_popen_read(bin/"ko", "completion", "zsh")
    (zsh_completion/"_ko").write zsh_output

    fish_output = Utils.safe_popen_read(bin/"ko", "completion", "fish")
    (fish_completion/"ko.fish").write fish_output
  end

  test do
    output = shell_output("#{bin}/ko login reg.example.com -u brew -p test 2>&1")
    assert_match "logged in via #{testpath}/.docker/config.json", output
  end
end
