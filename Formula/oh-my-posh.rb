class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v14.0.2.tar.gz"
  sha256 "b2c770903356ccacacc94b7a3bf616723efc4c24085259f77c3088dbf8ffbad4"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "faf8ee86f8613f114eea9c4fd0b52dc7f935869ba7b14548815c2cebca4746c8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "58cdd3e04503aab52b70a203eb6fd268c38dd53aeb144deda8f151a2f26a6362"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7f587bf20121f129a726cfd57207af86d5a292fff85d68b4cc181cbafbf1eb36"
    sha256 cellar: :any_skip_relocation, ventura:        "a0693da385a46954e09dbb52b0666f7aede0319a5b6315f03dc674a67ffd45ec"
    sha256 cellar: :any_skip_relocation, monterey:       "36c54d95a42b1c723d85c8e8114cace89a209900b08ae4757abbfe7d771fa01b"
    sha256 cellar: :any_skip_relocation, big_sur:        "7fe4ca731d6feaee0caa9177740697c7eb5ab1125037173ac8db59a4b9e1b0be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8b85cb48b1d58602e01e0c6d937bb26d87165201449166957085f45e6165186d"
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
