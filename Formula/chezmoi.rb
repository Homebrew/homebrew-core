class Chezmoi < Formula
  desc "Manage your dotfiles across multiple diverse machines, securely"
  homepage "https://chezmoi.io/"
  url "https://github.com/twpayne/chezmoi.git",
      tag:      "v1.8.10",
      revision: "11ed57d9a7e86434744f336b595ed0fd19aff6f5"
  license "MIT"
  head "https://github.com/twpayne/chezmoi.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "3119ebdb1123a77c18fb6d4429bb4f747fcbce8a79f81b45238504ee97bbccf7" => :big_sur
    sha256 "f0c06a684a52e886e70fbb9dbae0a2152597a0fcc5d13e90f0ee0e04b0cbaa70" => :arm64_big_sur
    sha256 "6b01e98eec925df06c02cb47ee33136d340d9410570862a69de7a5aa8b820968" => :catalina
    sha256 "369c634fdc904be8d9c9af0ce2afe6adb7f90f8c43a15fc54a2969d2115715eb" => :mojave
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
    assert_match "version #{version}", shell_output("#{bin}/chezmoi --version")
    assert_match "built by homebrew", shell_output("#{bin}/chezmoi --version")

    system "#{bin}/chezmoi", "init"
    assert_predicate testpath/".local/share/chezmoi", :exist?
  end
end
