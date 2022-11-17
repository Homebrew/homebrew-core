class Chezmoi < Formula
  desc "Manage your dotfiles across multiple diverse machines, securely"
  homepage "https://chezmoi.io/"
  url "https://github.com/twpayne/chezmoi.git",
      tag:      "v2.27.1",
      revision: "b6039e787dfffe970fec4f9165ec9ebe1b3ceaa6"
  license "MIT"
  head "https://github.com/twpayne/chezmoi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "850a317e105cfc8bb052734a1b5ab78d6dc90006268973a838d0c2c89d9da224"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "adb947372549af1788d1448ca921de0fd5802fc9bea453a6f769f39e9cf9833f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "488d7b368a780603bc47999b6c720fb4d33d3003471f6c335815bfd54e5e0ed6"
    sha256 cellar: :any_skip_relocation, ventura:        "0f43de69de5fb740bd46de96778b31f43c2663b5ae38ff0bdae5ffae1bd302e0"
    sha256 cellar: :any_skip_relocation, monterey:       "b73d7fb681132058e44cd46865cf12739929794bc65bb53e89cc34a68335a554"
    sha256 cellar: :any_skip_relocation, big_sur:        "3d78ff35be3ef99dc76dd5db566cb416d41ac1ba23bcacc17568dcd6cefe6bca"
    sha256 cellar: :any_skip_relocation, catalina:       "25f7c2b564d55cbbb49c48fdce6995afc797eeab781365dfe6a0acb4042b781d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2bb3003b436e074ea9155460634404c025979dc8d72c8bd776ef4e0961827680"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{Utils.git_head}
      -X main.date=#{time.rfc3339}
      -X main.builtBy=#{tap.user}
    ]
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
