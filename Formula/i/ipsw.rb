class Ipsw < Formula
  desc "Research tool for iOS & macOS devices"
  homepage "https://blacktop.github.io/ipsw"
  url "https://github.com/blacktop/ipsw/archive/refs/tags/v3.1.687.tar.gz"
  sha256 "714e2cc1b74b51d5edf06c18e48074ae3170c25feeb82cb354e02f0ab9036553"
  license "MIT"
  head "https://github.com/blacktop/ipsw.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "399cb58bc0e0327cb38a9f7bd6fa28f5ae8f1dc2ce1afbafef1cc2e27956bddf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "36d5527f9548962d6d0b73c2491640317d17f4167872d35866bf9f00db95cf32"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "af17655dbe2103be8fe21d34e0b78ff8687de9c460cbbf796ddb3f63a53f1531"
    sha256 cellar: :any_skip_relocation, sonoma:        "ff20e51f86ab550d68894e3650bcfb4e2e7711e472b3177f7b803c86325e68d5"
    sha256 cellar: :any,                 arm64_linux:   "828c5eb97ede3d29e39eca0c2b30adeeaa177e45f0ec656e5be5cdb249bc69fa"
    sha256 cellar: :any,                 x86_64_linux:  "20af1028c7b3823cae4925f24ad98dc2b5395f5f2e2d415c10aebd0b2650511f"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

    ldflags = %W[
      -s -w
      -X github.com/blacktop/ipsw/cmd/ipsw/cmd.AppVersion=#{version}
      -X github.com/blacktop/ipsw/cmd/ipsw/cmd.AppBuildCommit=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/ipsw"
    generate_completions_from_executable(bin/"ipsw", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ipsw version")

    assert_match "iPad Pro (12.9-inch) (6th gen)", shell_output("#{bin}/ipsw device-list")
  end
end
