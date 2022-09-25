class Chezmoi < Formula
  desc "Manage your dotfiles across multiple diverse machines, securely"
  homepage "https://chezmoi.io/"
  url "https://github.com/twpayne/chezmoi.git",
      tag:      "v2.24.0",
      revision: "72d9846a7ae51fd3398727d48815fc2f13a681f9"
  license "MIT"
  head "https://github.com/twpayne/chezmoi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eeaa88bac03f6b297e0157f750746088435aaa35c30de461627f8d5629ddaf7c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ea2e69fffb482dd819862cd00b1f9f8ea29c39f01bc880439479f811ba71d351"
    sha256 cellar: :any_skip_relocation, monterey:       "fd79daebaa75e35c605938ea053cdddd5f7864a32c8584168576ac5c2f22d2ad"
    sha256 cellar: :any_skip_relocation, big_sur:        "0b4c3a61f92c846782a5f33a2898961ed9756507d435f000a3bf8afa0db554c9"
    sha256 cellar: :any_skip_relocation, catalina:       "a80906cc1971c4b48f31c7590e726618c3d32301119a9f85220206332862e840"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0aa85ea0a4db7b2d42f90ad5a9cc66372cd0d85a845f34ec3f3da79046707ae1"
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
