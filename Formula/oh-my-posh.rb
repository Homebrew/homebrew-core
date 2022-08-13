class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v8.29.5.tar.gz"
  sha256 "da7cf624380dd42dd8dee57b8f3f0c5c0b9c6792a482dcbae0f70ce37589e643"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d035640012c59379859de5b6ee9f9d1a7d9af2ca6652a8df8719b16d28590aea"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5ccec47d341645ad48f1c6a3ce5a86c0341f827714d544c1cbf5db5b92f64672"
    sha256 cellar: :any_skip_relocation, monterey:       "5f0a452c06d68900534cb0a9c74da7d89b4554ef2899088123fcd66a614a2f99"
    sha256 cellar: :any_skip_relocation, big_sur:        "a19e18539228685ca1fd90ee0084955e4dd35cec9c226540074d8a974da20391"
    sha256 cellar: :any_skip_relocation, catalina:       "b3c726c13fb29b21ce9109c16b972c458337c9beaa65aecdfb7730f3d3db992e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "66e110a109a006630c52cd908079e54833ea39748fef37d1933d1d699d82afd0"
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
