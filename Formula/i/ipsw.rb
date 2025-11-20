class Ipsw < Formula
  desc "Research tool for iOS & macOS devices"
  homepage "https://blacktop.github.io/ipsw"
  url "https://github.com/blacktop/ipsw/archive/refs/tags/v3.1.639.tar.gz"
  sha256 "16a963b40f5f90a54526bb416bb19909349cdb63a51953b52e184df09320c343"
  license "MIT"
  head "https://github.com/blacktop/ipsw.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "59b691604623912cbe9fb758355f30f907b49b5b36cb47960b77257f31c00b15"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3b5eff5fcb5be0542d56d83cbd0d7bac9a86b8a2d31fb4845591410f2435311a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "276843c55c5b45188af3636cccc95c800d4d0900f6d6fd18473017c9581d7eb0"
    sha256 cellar: :any_skip_relocation, sonoma:        "d26a7204e1e8c544f93354c06223d26b5c84a630f315ff37b66e7c5ca949d28f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "30ee23bce902153527644f1d09f18336d095336e8c3bdcc4f342092e161e6601"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cf0344d38c7d538d0fd6fa0d31e1e7efa3859fde55c0cfc1a6f004b055e7c26a"
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
    generate_completions_from_executable(bin/"ipsw", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ipsw version")

    assert_match "iPad Pro (12.9-inch) (6th gen)", shell_output("#{bin}/ipsw device-list")
  end
end
