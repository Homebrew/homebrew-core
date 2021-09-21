class Ketch < Formula
  desc "Application delivery framework for applications on Kubernetes"
  homepage "https://www.theketch.io/"
  url "https://github.com/shipa-corp/ketch/archive/v0.5.0.tar.gz"
  sha256 "ec58636bebafa7723ea52ad15c6a5a03b03be29c64e4fff2fc9646503e54f336"
  license "Apache-2.0"
  head "https://github.com/shipa-corp/ketch.git", branch: "main"

  depends_on "go" => :build

  def install
    system "make", "generate"
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "./cmd/ketch/"

    bash_output = Utils.safe_popen_read(bin/"ketch", "completion", "bash")
    (bash_completion/"ketch").write bash_output
    zsh_output = Utils.safe_popen_read(bin/"ketch", "completion", "zsh")
    (zsh_completion/"_ketch").write zsh_output
    fish_output = Utils.safe_popen_read(bin/"ketch", "completion", "fish")
    (fish_completion/"ketch.fish").write fish_output
  end

  test do
    assert_match "no matches for kind \"App\" in version \"theketch.io/v1beta1\"",
      shell_output(bin/"ketch cname add brew --app brewtest 2>&1", 1)

    assert_match version.to_s, shell_output(bin/"ketch --version")
  end
end
