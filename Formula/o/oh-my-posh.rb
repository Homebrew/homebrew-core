class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v26.1.0.tar.gz"
  sha256 "d138949ccb7314f2540d8cb5d8bed880db601b0c3b62b54a8852c39b58ce1b1e"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a2ba19fdbfb606a00dcff95a47e8d837fcd65e968ad7f457dd37be66f178c703"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c76ec1975032dc1a5a595d069697563bee99c3b568a8f08d2238b7e6a63430d7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b5114412492b38cb7aad4d702b031d76a2415f0fb03b44e81ea332535c4ad0d2"
    sha256 cellar: :any_skip_relocation, sonoma:        "1d8504347c04a1542a2e98711d13c53f7a625d644d870c92ce0a5dcdc9aedd1f"
    sha256 cellar: :any_skip_relocation, ventura:       "3cf126bf2ccade0d3517b2ea509712a43abfd14c2254caaa828e1f85a274a425"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2502b8f14120fe63e13c956e62ebf9a79ad79b35820be0965c597e0a3edeb60b"
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
    assert_match(%r{.cache/oh-my-posh/init\.#{version}\.default\.\d+\.sh}, output)
  end
end
