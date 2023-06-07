class Chezmoi < Formula
  desc "Manage your dotfiles across multiple diverse machines, securely"
  homepage "https://chezmoi.io/"
  url "https://github.com/twpayne/chezmoi.git",
      tag:      "v2.34.0",
      revision: "006230cc05fc1fe017c942758ee92aee3058d9c5"
  license "MIT"
  head "https://github.com/twpayne/chezmoi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "629234d494a41cc73d05ac7dd7e2253d8c570b59802c56932ebcf7cbf963a95f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "179f884946fe639d7bbd145b5f91648ecfebedd7a4431ee026b9efc64bfd3a38"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c18b410f52caf4015f1bebbf781449e5a22a51582b41a4c7249abff8c47b5bb3"
    sha256 cellar: :any_skip_relocation, ventura:        "4e5ba20de278a16d5f0a195f5e38b8323eefeeaa570209cb026fbcb70e39caaf"
    sha256 cellar: :any_skip_relocation, monterey:       "518277d6334dcaee959877ac62ed2439d6666d0b08b30390973b37b005d99b7e"
    sha256 cellar: :any_skip_relocation, big_sur:        "07ce3267c2dc06f59dc2f009cb3564a12cbf4e830dbdf2af6e51fb30d09ea70e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cb8ef091f295f36ae3b800da662c50961ef29571d745bf90f2a53de6227b4000"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{Utils.git_head}
      -X main.date=#{time.iso8601}
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
