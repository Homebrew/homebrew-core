class Chezmoi < Formula
  desc "Manage your dotfiles across multiple diverse machines, securely"
  homepage "https://chezmoi.io/"
  url "https://github.com/twpayne/chezmoi.git",
      tag:      "v2.0.4",
      revision: "9cc8184cc466a87c44006218e02365046e5d5f8b"
  license "MIT"
  head "https://github.com/twpayne/chezmoi.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "11e2774c410b2a3b69df41eff1d229c65de2c677985f93e7858c5d8c55682d60"
    sha256 cellar: :any_skip_relocation, big_sur:       "322778ca009136099d020dd71c27d74f73b2be5aa1dbf2b8207263442cb5d9e5"
    sha256 cellar: :any_skip_relocation, catalina:      "ceb46db12e8b18dd34b1498e0dd99fe0f948ca25d48142733a4cdb1254f21505"
    sha256 cellar: :any_skip_relocation, mojave:        "b7785bcfc46186690d36a2cfa545506b60b1d35b4f1663ca824d783f00fce189"
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
