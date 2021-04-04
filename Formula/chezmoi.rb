class Chezmoi < Formula
  desc "Manage your dotfiles across multiple diverse machines, securely"
  homepage "https://chezmoi.io/"
  url "https://github.com/twpayne/chezmoi.git",
      tag:      "v2.0.9",
      revision: "7c7213b32435823ce3fd0dc468fdecefe7c5e8f9"
  license "MIT"
  head "https://github.com/twpayne/chezmoi.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "ab5901af3992154a5503ec049fa5bb6fe264e271b2bee034a35230f1d4f1b91e"
    sha256 cellar: :any_skip_relocation, big_sur:       "4553a8a35ed02125de6c9ec2c19dead75ac2d044ff80dac7174b75fb7705c3cd"
    sha256 cellar: :any_skip_relocation, catalina:      "2ba47bb8f6194c7cd698647f92b83f4ad47800fe986931da4d3e2eb300462476"
    sha256 cellar: :any_skip_relocation, mojave:        "07270b65c0e77b06b3bb17972233ca2b828ad702f06dab5b1fd8423b9aeb1e12"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{Utils.git_head}
      -X main.date=#{Time.now.utc.rfc3339}
      -X main.builtBy=homebrew
    ].join(" ")
    system "go", "build", *std_go_args, "-ldflags", ldflags

    bash_completion.install "completions/chezmoi-completion.bash"
    fish_completion.install "completions/chezmoi.fish"
    zsh_completion.install "completions/chezmoi.zsh" => "_chezmoi"

    prefix.install_metafiles
  end

  test do
    # test version to ensure that version number is embedded in binary
    assert_match "version v#{version}", shell_output("#{bin}/chezmoi --version")
    assert_match "built by homebrew", shell_output("#{bin}/chezmoi --version")

    system "#{bin}/chezmoi", "init"
    assert_predicate testpath/".local/share/chezmoi", :exist?
  end
end
