class Ipsw < Formula
  desc "Research tool for iOS & macOS devices"
  homepage "https://blacktop.github.io/ipsw"
  url "https://github.com/blacktop/ipsw/archive/refs/tags/v3.1.711.tar.gz"
  sha256 "a108e07453da2f8dfcb72664882330630549af8bbe109749859d7b4b5dca310a"
  license "MIT"
  head "https://github.com/blacktop/ipsw.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c30e172c5b138d1908cbc74a1e3610cbb8943cd4c7a1fe2789caff64c297bcb2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5fc48cb4f6effa5958e1bc8acb85859ca41fc4c15bb8f033d1b94eace094f561"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "165930c563a0818fa7c14848603c7c76f3b5a608a7488ed9d7adf7a3c3081a19"
    sha256 cellar: :any_skip_relocation, sonoma:        "81dacb7a96a684f9ccd40cc272d13aa90f0e5e8e7ce6e085978d05c32260311b"
    sha256 cellar: :any,                 arm64_linux:   "7165e129e0af824b1374fff96eff5d897298fff6cb235e180d33499d9f77154c"
    sha256 cellar: :any,                 x86_64_linux:  "f096c3a5d19f6740912c172bcd373d0f26689addff82b1eaa1cd1205ff246a08"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

    ldflags = %W[
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
