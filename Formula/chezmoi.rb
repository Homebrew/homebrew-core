class Chezmoi < Formula
  desc "Manage your dotfiles across multiple diverse machines, securely"
  homepage "https://chezmoi.io/"
  url "https://github.com/twpayne/chezmoi.git",
      tag:      "v2.18.1",
      revision: "89f8b0ea0aa4e3add6e1bd2706d3db22373968c8"
  license "MIT"
  head "https://github.com/twpayne/chezmoi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2c5dbda1ac31a9066e88d63862f727f479357cb62fa6d61de49b66fcdf452e45"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b2a7ec6450c89257a4ce6c82e358d301156b53359f5465219d7a9a50f064cbde"
    sha256 cellar: :any_skip_relocation, monterey:       "cd13c63ba584beba95e49f5581dce6d132ad78c355ea76a419e098ab2e616a77"
    sha256 cellar: :any_skip_relocation, big_sur:        "e4b70ee78cad610394e9f0c17b5f2e978dd50ce89ff3becd86183990ac47a2c0"
    sha256 cellar: :any_skip_relocation, catalina:       "406b92689bc93c2ebcacc366c899248cbc749c9c88438416a7e25fe72604af0a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "163a25fa8a5c3a1b7c9d7a37175e005caddd80d9f0ce69e0de3c7dd4dee560b1"
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
