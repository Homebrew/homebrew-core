class Chezmoi < Formula
  desc "Manage your dotfiles across multiple diverse machines, securely"
  homepage "https://chezmoi.io/"
  url "https://github.com/twpayne/chezmoi.git",
      tag:      "v2.15.0",
      revision: "702cc4db2e19ebd246df58a54522d30959d18cd5"
  license "MIT"
  head "https://github.com/twpayne/chezmoi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ede5ed3f69c22944b41704e6ebb7fab7123b3ebc7f055ad2c30c819464d6f842"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "45c0cdd53f110a5dad56a1689ceec795e2d6c09290e59e132561b2ee80ef39bf"
    sha256 cellar: :any_skip_relocation, monterey:       "faab4dd7f6f2a61acacb53c3988d8c982264ace714a09dd12eafa91fd2f5f102"
    sha256 cellar: :any_skip_relocation, big_sur:        "435330189ffee4652cab1ffda939cd521d6aeae114d2d645b1d55896da2231e0"
    sha256 cellar: :any_skip_relocation, catalina:       "e2067775daf057fe179564ea162c0873c0adde7587629e6b66bbc209a83ff895"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "93af243b66137bc82619f43445bf4d916ba47f1e415f38e21256484ee71077f2"
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
