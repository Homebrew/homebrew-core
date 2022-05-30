class Chezmoi < Formula
  desc "Manage your dotfiles across multiple diverse machines, securely"
  homepage "https://chezmoi.io/"
  url "https://github.com/twpayne/chezmoi.git",
      tag:      "v2.17.1",
      revision: "565cbbe117746aa6bfec5f2cee20ae4cbbb5e645"
  license "MIT"
  head "https://github.com/twpayne/chezmoi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9d33ef250d0ae1bfe1f65f29dd98f2b65bb5dc18e6142b92d0d4fa1fb66c5931"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2ca31d2240fcd5d17fb5de3d1c61742c16cb3f00c68b74c4970f68e0900a38e0"
    sha256 cellar: :any_skip_relocation, monterey:       "d6c2c7e5f90a4e9ffa147541ddf8f0b8d962d6e39ef372806cf8cf45ec6bab9a"
    sha256 cellar: :any_skip_relocation, big_sur:        "d82dc2305d48539c6c6276f5d0043bf9cc24acb14a50ac33f4143d7262be8adf"
    sha256 cellar: :any_skip_relocation, catalina:       "e1d31b75dc26149ac66347c9c7b524844843bba36c8b599d370905fb47dd35ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cfc34da890ffb7f9bfbb08631e9cd7d9c447ef35167c9adb171ba5dee1b7cd52"
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
