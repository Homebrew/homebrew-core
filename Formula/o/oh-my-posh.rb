class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v29.13.1.tar.gz"
  sha256 "4316d8a4316e06e9202f4ab62fd99fe56195e1f90e929537e5301e240094c35e"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b8935709e68692aabd9054392c500e8181c610e125e666256112f47aedee0633"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cafbcbfd34edf3cd4c6ba3cf11cf94e8c048933e61d981a439c8a68a0de2dd01"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b3c97d07a0b3819a154617db2bba94fbaad9c6a6e9f453beb0fb189712569257"
    sha256 cellar: :any_skip_relocation, sonoma:        "98a5472ad8b623e68f1bb3e6bf8b169de33a5f600d5283fc1595702ce13c0ba5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0553b7b1233b99f87d7e5fc80aab871cf54fe22f45bf045e275da6822c9ac973"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b30da3b7cb5f20d9c897ebce666de14a6b4b5a0e5c362efb607941b1c7501b3a"
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
    assert_match version.to_s, shell_output("#{bin}/oh-my-posh version")
    output = shell_output("#{bin}/oh-my-posh init bash")
    assert_match(%r{.cache/oh-my-posh/init\.\d+\.sh}, output)
  end
end
