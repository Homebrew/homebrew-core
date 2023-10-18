class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v18.14.0.tar.gz"
  sha256 "f90c4685bbc065fbbf9ea124e19382303de3b5aa1761e054e42d69750593c6b8"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "499a9e45ef8373a78044b1fac3b74419acc4b01e09240915d7a99b2595178cef"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "789b8d0f8dcf9bcd74d2c35c9870f1dc351c9a6dfef722b9f358e888036e619a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "16f018efa2d7a6aad73648dcf528c9bdd709d8eaa5cddcafb30f4189c69adffb"
    sha256 cellar: :any_skip_relocation, sonoma:         "10f00a807e02516490d4f8c89d09449f6d38e26bf0fedb3c9ad8d7d7a7ec1ff4"
    sha256 cellar: :any_skip_relocation, ventura:        "88d757c80169c7d7171491c2ce9ea9c48e75117f2259eb6c40ee096049c5bd34"
    sha256 cellar: :any_skip_relocation, monterey:       "943b1103b264c7bed0bfb8283e3858c1f592b7ad7629f396108eb28b7e24509f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ad18e006592c414b5ffee457dda7e19590c9b1585438ee83cd3cbdc62317880f"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/jandedobbeleer/oh-my-posh/src/build.Version=#{version}
      -X github.com/jandedobbeleer/oh-my-posh/src/build.Date=#{time.iso8601}
    ]
    cd "src" do
      system "go", "build", *std_go_args(ldflags: ldflags)
    end

    prefix.install "themes"
    pkgshare.install_symlink prefix/"themes"
  end

  test do
    assert_match "oh-my-posh", shell_output("#{bin}/oh-my-posh --init --shell bash")
    assert_match version.to_s, shell_output("#{bin}/oh-my-posh --version")
  end
end
