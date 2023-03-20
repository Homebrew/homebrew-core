class Chezmoi < Formula
  desc "Manage your dotfiles across multiple diverse machines, securely"
  homepage "https://chezmoi.io/"
  url "https://github.com/twpayne/chezmoi.git",
      tag:      "v2.32.0",
      revision: "5ac7d4e8e6589c5deda835d84469831f345c6847"
  license "MIT"
  head "https://github.com/twpayne/chezmoi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "df0b1b7e19caacc67951620a102b87c3d8f8a58c66fe8c1fe3ddb5d5f6c44f16"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fa9a1e4a453c22611fabc315b5df5a2ed0c92f343970831e7815b06f3d6f4b8d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1d8a2eea8eb61249922a252338f77df3c4892f90a88f918ba20685e5569cf4e9"
    sha256 cellar: :any_skip_relocation, ventura:        "4ded41dc9aed484bca135c3f5f9bd33ea830c483b7d3bf1b9899538ad78ab503"
    sha256 cellar: :any_skip_relocation, monterey:       "555a304362beb4b8e81cbe0e0f4936c83ddd3157def2e9eb306a19f34c7286e6"
    sha256 cellar: :any_skip_relocation, big_sur:        "17fd3616435b8039aa3707c7c8bb957a813c40474fb62665fa5b441037335894"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "20228f81cef6968cddbd6cb79a8a152468d774fd33de507ab0190583311fa7cb"
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
