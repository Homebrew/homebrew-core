class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v8.6.0.tar.gz"
  sha256 "bfff84b9a3f0d19aafbf02c0e1dc62c7f26b8491f6d5ba6bbda0ce599dcfa463"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c49003dce53ab6228fe8674d4348ef811f1cb29fc54a057cd0b88243c72211a8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "46c4d85ce4b281f909ac35aecaa4aa5f011919968bbff272673ba6d93b091073"
    sha256 cellar: :any_skip_relocation, monterey:       "b482b309cfdf40d4a405724ae1dee48c267dda8d48c75eb9b67487a78ed8dde3"
    sha256 cellar: :any_skip_relocation, big_sur:        "41d5811013f9be646a6f585a341e72e619c6eedf32640bfe8c9eec06401157bb"
    sha256 cellar: :any_skip_relocation, catalina:       "830ae1537ae4078ceabf05ad325c4e6490addff4e847512a969735427985b994"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "873fa6edde7d6dc440fa378a01b2574bf3fcf59f505f2143b2bf3309bb17f796"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.Version=#{version}
    ]
    cd "src" do
      system "go", "build", *std_go_args(ldflags: ldflags)
    end

    prefix.install "themes"
    pkgshare.install_symlink prefix/"themes"
  end

  test do
    assert_match "oh-my-posh", shell_output("#{bin}/oh-my-posh --init --shell bash")
  end
end
