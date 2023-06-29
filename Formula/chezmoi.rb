class Chezmoi < Formula
  desc "Manage your dotfiles across multiple diverse machines, securely"
  homepage "https://chezmoi.io/"
  url "https://github.com/twpayne/chezmoi.git",
      tag:      "v2.34.2",
      revision: "473189051ec4950baa342f19ae7a824f0c1ded1f"
  license "MIT"
  head "https://github.com/twpayne/chezmoi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5276c9003ccd2706aec4e9cd3458cff9d07d42a204bddcbced2b568efccb3856"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6664e528b235bb11101d6894eaac36645d8d0cadb222d068fbafdce64ec1c884"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4d129f93a66eea00649cee587bd0828019cb4391d72588bb01700f67459ee4c1"
    sha256 cellar: :any_skip_relocation, ventura:        "fed44855c37f1ddd787c2707fcbe831bdb87274a82a5e01b5c83842a135eae72"
    sha256 cellar: :any_skip_relocation, monterey:       "2f6ce0a186bcb90935d3caeb5e6bac0f62b01c27a0a0f2f5663636a74a38c4e2"
    sha256 cellar: :any_skip_relocation, big_sur:        "199b412448ee4f44850a01d0ea2f5611b48f6d717e7236db9f3c23be1caadb16"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4ccbcbe172382a0189f04490478ec63cdf920b5b11448f8e55c569e4ac8d326e"
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
