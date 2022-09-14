class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v9.2.0.tar.gz"
  sha256 "3711efab88b4dc9d2bb318455c813a263622bad50be62a7cddde6fa6dbfaac9d"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "98f2bfb2edf5e675d887d6251e5075b226085dd419d6e07dcf2393aaf0c6ad20"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "08b25ba5ed60d87e78dc0c9d27b2520f389846b332daf67a1717c44a347c71e9"
    sha256 cellar: :any_skip_relocation, monterey:       "4b9438a2068fa0e3361c2d891a7cd96d959474fe9bc9868d89d8b4d2a02d01c0"
    sha256 cellar: :any_skip_relocation, big_sur:        "9815710593b389b037c22007b569cbc9dcd31578c707ade1b148f692faac9bc5"
    sha256 cellar: :any_skip_relocation, catalina:       "8de8fbfd590403ef72dd3ad26bc4d9112ee7ed3b2d42f54ad3fd32d2e915a3d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f003f1a88531a29b85811758b071d45ee15d3d5bec2363931fc7b7c8a92e9bc9"
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
