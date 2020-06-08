class Chezmoi < Formula
  desc "Manage your dotfiles across multiple machines, securely"
  homepage "https://chezmoi.io/"
  url "https://github.com/twpayne/chezmoi.git",
      :tag      => "v1.8.2",
      :revision => "323cba56195179ade6b061fa2d6af37d16cd193e"

  bottle do
    cellar :any_skip_relocation
    sha256 "61ef716065504bd6701e0a05d139b9991b435126a574caf73c69e234b899fce9" => :catalina
    sha256 "b4965b598bb3d1824f6f21eb93752f5c6575ce2f7f82e72fc4ba1a2cd03b14aa" => :mojave
    sha256 "dba71d0e8671d2c4fb3bb3820a1b6cda5f40a839f963fd920dc254d6e96eeaa0" => :high_sierra
  end

  depends_on "go" => :build

  def install
    commit = Utils.safe_popen_read("git", "rev-parse", "HEAD").chomp
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{commit}
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
    assert_match "version #{version}", shell_output("#{bin}/chezmoi --version")
    assert_match "built by homebrew", shell_output("#{bin}/chezmoi --version")

    system "#{bin}/chezmoi", "init"
    assert_predicate testpath/".local/share/chezmoi", :exist?
  end
end
