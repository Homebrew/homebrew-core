class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v7.93.0.tar.gz"
  sha256 "62cbee7b69e7f8cce28f558dde1ee30bbef84afbfd9792b1fef44317b424823e"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cb582138461c3ac3a7a43286b24259030b805a760d9e89e288cd6c962f13035a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4d893a269164a032a6951b9defc51e595a2bacb4b7c4ffe9091fa4e0041bf6fb"
    sha256 cellar: :any_skip_relocation, monterey:       "1c878bdb99caa968cbb12a3e465c72c91f985e58823b70fa92f80d7fef4b6266"
    sha256 cellar: :any_skip_relocation, big_sur:        "6cd7a4fff0e39f8b481805936ab948e085d6aa9968a61b680d759c6ffa9f4c1e"
    sha256 cellar: :any_skip_relocation, catalina:       "4fc628313c4ea2e0b7b4f344a12483ad5a6bc3c9c51c745d8484041bd7b3bca1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4645671e46fad07a4f5156be06146c5caedf277b1f0fe2849c51332b76a68155"
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
