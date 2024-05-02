class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v19.25.0.tar.gz"
  sha256 "dc1019157ce4c50f45160c6d594340da59f85ff94d35fc3b62b878e98e75af8c"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "89e13323974682ae7628dc0bfa33b00bf4cfe3815eedc82a3374e8b52166c8e4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a431dbd9683f644c677345813ed528746604cd753888c3735a991d247124ad51"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "29d06b83e1a6c8f9c08e30c50d7461f2566cab06cfeea92ec39e15f731545a02"
    sha256 cellar: :any_skip_relocation, sonoma:         "e515ac1aafb652e51829667120c7ace4c118631aef5e452ad0b69bfe50421b55"
    sha256 cellar: :any_skip_relocation, ventura:        "44312b79f2884ab628f3cf457c19fe2e091091c1e3263e7b798608a166344f4d"
    sha256 cellar: :any_skip_relocation, monterey:       "a5b63b172665767ea6bf4a3db855ec88bf07010c1ca6d2c842ba988b4849af48"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "25f447c1e1a462ff3f1c9b6bc0dc412710f7a6d8c9cb061cdfcfb5d58b2f19ad"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/jandedobbeleer/oh-my-posh/src/build.Version=#{version}
      -X github.com/jandedobbeleer/oh-my-posh/src/build.Date=#{time.iso8601}
    ]
    cd "src" do
      system "go", "build", *std_go_args(ldflags:)
    end

    prefix.install "themes"
    pkgshare.install_symlink prefix/"themes"
  end

  test do
    assert_match "oh-my-posh", shell_output("#{bin}/oh-my-posh --init --shell bash")
    assert_match version.to_s, shell_output("#{bin}/oh-my-posh --version")
  end
end
