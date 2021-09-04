class Chezmoi < Formula
  desc "Manage your dotfiles across multiple diverse machines, securely"
  homepage "https://chezmoi.io/"
  url "https://github.com/twpayne/chezmoi.git",
      tag:      "v2.3.0",
      revision: "076e381b87d2449496a5080781c82cc013182e35"
  license "MIT"
  head "https://github.com/twpayne/chezmoi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "f97c890d1017c9fff7eff5a394b6fa24053c94df8dc9269245e94a8b65c89447"
    sha256 cellar: :any_skip_relocation, big_sur:       "94b25cdfd84e0e1ec6883a3a0e332c0106e64a264a48dc3f31f00c6fcfc5cae2"
    sha256 cellar: :any_skip_relocation, catalina:      "5978d2e56671e8b5a21757a4a3d34e85076883e2ff67df255bd3c303b26580f5"
    sha256 cellar: :any_skip_relocation, mojave:        "1034b4b336092538f4917218cdf3d23548ae04d636f008198360e3bf54eb0847"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f9096ff302242c9b65d3bd23b097180ae06d9462a736003ac80f152b8abf837d"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{Utils.git_head}
      -X main.date=#{time.rfc3339}
      -X main.builtBy=#{tap.user}
    ].join(" ")
    system "go", "build", *std_go_args(ldflags: ldflags)

    bash_completion.install "completions/chezmoi-completion.bash"
    fish_completion.install "completions/chezmoi.fish"
    zsh_completion.install "completions/chezmoi.zsh" => "_chezmoi"

    prefix.install_metafiles
  end

  test do
    # test version to ensure that version number is embedded in binary
    assert_match "version v#{version}", shell_output("#{bin}/chezmoi --version")
    assert_match "built by #{tap.user}", shell_output("#{bin}/chezmoi --version")

    system "#{bin}/chezmoi", "init"
    assert_predicate testpath/".local/share/chezmoi", :exist?
  end
end
