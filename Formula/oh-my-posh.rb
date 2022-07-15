class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v8.18.0.tar.gz"
  sha256 "fb7b632907c07dbe0cece913dcdc8c4b8f1d4227427819cdb5c09e8041214f16"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "70a649b9db36d562ee4b3da9b91e50ac10a5514ceb3ca2bacc07b3c9b6fb1ed5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "947dd6e525b39d40cbd306cedafc553f0dfca16a733402c6e3ed373cf93df67b"
    sha256 cellar: :any_skip_relocation, monterey:       "b1b25ed14946e907f1c9134ff2c3a582a966f9554b51024b19e44d582b3a473c"
    sha256 cellar: :any_skip_relocation, big_sur:        "971b5fdaffa1fbb3391dbb057ac6b830ebdbc0b4777869a7fa333336710ae7c9"
    sha256 cellar: :any_skip_relocation, catalina:       "6fcc85b849d307232fce7483122a40e780d5f2f0d091af32343d7fece2449f8e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "74d266f315addbb6a5b008c6052fbe9a7aae5a1ad281fafd586e053260840293"
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
