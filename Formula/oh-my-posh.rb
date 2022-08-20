class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v8.32.4.tar.gz"
  sha256 "d2b624af33887e30969f88e8cf7a148a208848769d8a6514140526447c0537ee"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4614aeb7a2ac06e061879edb9b56933cabad6e5adc8119752a71d5acf3c9f912"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8d3af7aad53c0f22c1d94793887231b78debb7f5368abad256d5356f21edfe5c"
    sha256 cellar: :any_skip_relocation, monterey:       "57666c5a0e70542e3442348f30936882ace106ad4d7c470fe91383c32ec137e9"
    sha256 cellar: :any_skip_relocation, big_sur:        "0bfa36ecd3d9181c465a17cd47f8955a852ece6f563d08da297c389b4711b070"
    sha256 cellar: :any_skip_relocation, catalina:       "f013d5a8b59137a10df1053c564a082976ebefb9a5fc232300adf940cec95d70"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b0e4d09cc5ad8c76d5dda5a859343ecad94f1d70703f3cb248eb0ef742f13926"
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
