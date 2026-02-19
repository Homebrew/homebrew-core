class Ipsw < Formula
  desc "Research tool for iOS & macOS devices"
  homepage "https://blacktop.github.io/ipsw"
  url "https://github.com/blacktop/ipsw/archive/refs/tags/v3.1.652.tar.gz"
  sha256 "2204d0fda00cf94f7bcac3c859f13fcd35ac1483cfbaaf20ce3edc51d78ea895"
  license "MIT"
  head "https://github.com/blacktop/ipsw.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0704f03c18273b3fec6254ce23bdef2765c04fc00d9ae70bea1316af6c4d0156"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "672b306e2e764039b95da23b27e3b65e1421c9594062b0e2ac88c8d36b77bb35"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4fb93b6fd21cefd467fac4142eb323bfcd66f72ebe3226b4cf97e592b0848b7a"
    sha256 cellar: :any_skip_relocation, sonoma:        "e10f3ccc86d8f9d2b9b12b247c0bd6dd77baac1e1821817ec250f1899396b566"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fc32be4498ea6c4b7419aa2ef6bc70cff542aed84c9dc8759b8ce0e8395943b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4d607d365a740720c636178a2a982b0fd97d4e6bc6451c471586916968fa52a9"
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
