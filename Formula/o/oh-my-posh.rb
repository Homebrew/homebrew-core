class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v18.22.0.tar.gz"
  sha256 "4ac01dd56a0bf0779fccdd2b7982188462f0ebaaaba334bf773cc485d15acd2c"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "856c2820eed84a6ab5c0b649bd9e6a6a565dd31e8a48e5118d72d2e8e7a6f9ce"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "46454ad870167cd13207080101cd5853e8493a8f819cc837ba5912cd4dcd9ed1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5c8c4c8504d2af6389c20af79ec7fa738f23dc7df1821123ac816bd180a07fd0"
    sha256 cellar: :any_skip_relocation, sonoma:         "d5f9d6c67570dd205563418d25417bf433293b4e664582789a6065d657be9e22"
    sha256 cellar: :any_skip_relocation, ventura:        "fc5139f3a2a7d78257d58fb8e2693a62b07baa6839b00eadf39b8570ee7db976"
    sha256 cellar: :any_skip_relocation, monterey:       "7202d4d53b815351f2377c8518074ad1c0e5cc3030955d24d5d375efe059faf8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cab9cb218b24e660408f1a7e5f33a02efd5e006c3778c259f33a795f3836893b"
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
