class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v27.6.0.tar.gz"
  sha256 "0274ed09004081c86d69ec6ff73d134e8cde602ab35c974cd036399bcb8bdced"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3d552b5facaccdd643b084d33cf8cc51425bc8a898b94ae8ff7cc589f3e4d6da"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cfebc9c2cd9d500c4e26298c4a13b33954f2cd40f67d6660cb32aeb36c4f347f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "65e5db0b298fb62e7c13bb24931fa59d43f1eb6ddfdc6d529efd60b6aeb64391"
    sha256 cellar: :any_skip_relocation, sonoma:        "0d1074c359aed3066059aa867a9be4460606b7bff18e736b6c42182a18dfed4d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "43676d460ce7e87cd17abc6865781a5cd1c264687a848a24f0e4d645fd5715d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2c9477fda1c646abd6646ddc8b469b5cbc157ac16ff2b26c8f31ed0a1301056e"
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
