class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v26.23.8.tar.gz"
  sha256 "b06d88ced3e869fbbba4b741f99bbb431fe0f4666974219fd34f3cbb443cfeba"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "26a988db2d5bd42c88980d9ca8bebc6367a2ecd6bd664bd5fb3496321c801107"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d79604da6eac0ce8671b9f939cfa64086bbfe35f125c861f2f9f0c68a653dd3b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b4fa84038777047e2fcd664e1b6bef7311868abdf227b45c3c2f70e345f4b8d0"
    sha256 cellar: :any_skip_relocation, sonoma:        "22935e7a044907971a16b03929e5be4a9ee1f0d6338c02ede6bebcc3212d59d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "56decc41e69ad0f599b3f5304dc54697a062bd40d5ce712e7a8a7aedbb1567c0"
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
