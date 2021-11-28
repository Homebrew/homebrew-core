class Chezmoi < Formula
  desc "Manage your dotfiles across multiple diverse machines, securely"
  homepage "https://chezmoi.io/"
  url "https://github.com/twpayne/chezmoi.git",
      tag:      "v2.9.0",
      revision: "f9ba484442ad5ec2cc1c14fffa5fab05779546c7"
  license "MIT"
  head "https://github.com/twpayne/chezmoi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f409917e2d11e9fb9ea5683853d21e2efbc0251100db6650ae5ac17b5639670a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bd344df880a1af55d077413d36e65112a2c7e658602270106be93732ecdd9305"
    sha256 cellar: :any_skip_relocation, monterey:       "9659f4875d6f65e1a3b07aa4c9b50684f8681ec8a0049f37750ce1bd6c11c67d"
    sha256 cellar: :any_skip_relocation, big_sur:        "b315dd078ea3ae406b75eef5373e86f7d770aa0245f6c0deb344eb2cc6aab328"
    sha256 cellar: :any_skip_relocation, catalina:       "9bb551aef35d8fb9959a2e7c22dd17f85d32b4a5a60b00beb0d360c8f7ee00f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8b37b5e8026b3b05331fc5f16444afb486f456032ce27472f1bef0645eada036"
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
