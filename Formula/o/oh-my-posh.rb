class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v29.23.0.tar.gz"
  sha256 "8d66831de1e100ca61b8fc0bfccbdca61c4b01e939d972fcc03195b38e52ab68"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "acd409bc9041fb2b30a0e0366745a0a9f3dcfb06fb0373a23b9ed37403b591a7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b1da8f771694d74a114f824a8ac681d49d1b59b80e974b387923d70fc24ba026"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d2599675b79e6838091d4a187d95e9d1664a9bf227ce96b2334ee2ddda519d14"
    sha256 cellar: :any_skip_relocation, sonoma:        "d32b55fa50197fe0188e7469cf8845cda4aaf3dcf4aa8a37c921c371efa986d3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b223509bd3cacf5ca08f0c63f354979fdc38415c0c7346a1126c126423b54025"
    sha256 cellar: :any,                 x86_64_linux:  "bf2a76e21baf94980ec5af2ab0e0c931137f30f72f5ffe31d599d2943c74047a"
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
