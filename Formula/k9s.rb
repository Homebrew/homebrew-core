class K9s < Formula
  desc "Kubernetes CLI To Manage Your Clusters In Style!"
  homepage "https://k9scli.io/"
  url "https://github.com/derailed/k9s.git",
      tag:      "v0.27.2",
      revision: "3794a61eaffb5ccbd68fe128f7216db005d70f6f"
  license "Apache-2.0"
  head "https://github.com/derailed/k9s.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a2bf3918f0496cf215500cbb56b5a237689b1dfb8af1fe94af2079ab4b6a052f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ee57e6c24163c5cfda8fac7767844d47c25fbbb5f7b3cee231b9e71a84910a60"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "26feee45421046c13ca17b86276cf31fd23276692bb11209b1171dc8067028e2"
    sha256 cellar: :any_skip_relocation, ventura:        "9161991ee0800ed43ee0109b890f5f80c9dc9ede5d20777e808bc32dfef74fef"
    sha256 cellar: :any_skip_relocation, monterey:       "86c9e2cdf7be0d0463806ba75dfd6aa5d23f9e27afc168ad69a2a7310d6fbe9b"
    sha256 cellar: :any_skip_relocation, big_sur:        "7afce4fe5d80128f0b3bf9108211d4fd07314f64fbef16ec4314f48a8fa1da6a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1da58551d6e52cf37ad15aec25a25ecbf8f7abdfa78a3dcc942a4f5ddb75d822"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/derailed/k9s/cmd.version=#{version}
      -X github.com/derailed/k9s/cmd.commit=#{Utils.git_head}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"k9s", "completion")
  end

  test do
    assert_match "K9s is a CLI to view and manage your Kubernetes clusters.",
                 shell_output("#{bin}/k9s --help")
  end
end
