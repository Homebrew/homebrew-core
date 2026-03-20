class Ipsw < Formula
  desc "Research tool for iOS & macOS devices"
  homepage "https://blacktop.github.io/ipsw"
  url "https://github.com/blacktop/ipsw/archive/refs/tags/v3.1.665.tar.gz"
  sha256 "ea87783cca1839cee59152cb470da9039efe79eb2478f8f7ab29386889743f20"
  license "MIT"
  head "https://github.com/blacktop/ipsw.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "37fe8e14206a47398a9542c10d596294d5464100562a426a9378ea94edbd3170"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4bfb571c399375689654647b9fdfd865109eedabcefe1911c56b0815a000819f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3ba13e8d6da0b4650a6acb80c1ac15ebc538e3fceb8bbdb2e462caff4a713a58"
    sha256 cellar: :any_skip_relocation, sonoma:        "cfd7690d09e46c8fb7be226261201d5a426cc6756b1c6fdb2847ca4122052b6f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c28313a047b594d27f6f692d6927213c89e2fd4f0486a483a4322002a64cf643"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "09d0d9d66f7cc2c187203e5142d9b68d51edacbee474991d507dc4e6ade87124"
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
