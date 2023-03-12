class Chezmoi < Formula
  desc "Manage your dotfiles across multiple diverse machines, securely"
  homepage "https://chezmoi.io/"
  url "https://github.com/twpayne/chezmoi.git",
      tag:      "v2.32.0",
      revision: "5ac7d4e8e6589c5deda835d84469831f345c6847"
  license "MIT"
  head "https://github.com/twpayne/chezmoi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "252d637602e018c1f69e3b5c2af2444d777378e33ce27f308f801d77d2649939"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3dd50b3d55fcdb73f575b5d8e64c9a1acdaaeb99a29e1035e2f0e0ddfcc3a118"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "36e2e5af11dc7b02768d47c520bc92fa7283e6076a2adc73461fdc96acf39d1d"
    sha256 cellar: :any_skip_relocation, ventura:        "16dc5ad6a21f33663b9eff0f7cb39a801ae9ea7aa929ae26271ef6851a893d4a"
    sha256 cellar: :any_skip_relocation, monterey:       "4df9b3e4e31054ff434f2c23a4133a58a9c6ced0d3b987ec398768849459dc15"
    sha256 cellar: :any_skip_relocation, big_sur:        "807bb774d5fa9d9e61379cdc28a9766e028520d6abf17ca81299e0dc562eed90"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dca4926f56982efa6ed4148a27842cf4b348b5172dcb9ab94cf06de65244e749"
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
