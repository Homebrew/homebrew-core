class Incus < Formula
  desc "CLI client for interacting with Incus"
  homepage "https://linuxcontainers.org/incus"
  url "https://linuxcontainers.org/downloads/incus/incus-6.20.tar.xz"
  sha256 "8f45728eefe3fe3e77478ddcac2a0b883adf77bb80f3f786c69177d33b15e7bb"
  license "Apache-2.0"
  head "https://github.com/lxc/incus.git", branch: "main"

  livecheck do
    url "https://linuxcontainers.org/incus/downloads/"
    regex(/href=.*?incus[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8f189327750072416087ac908d2e0ccd0dac16bece35b7f24f232ff1c067e439"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8f189327750072416087ac908d2e0ccd0dac16bece35b7f24f232ff1c067e439"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8f189327750072416087ac908d2e0ccd0dac16bece35b7f24f232ff1c067e439"
    sha256 cellar: :any_skip_relocation, sonoma:        "7bc6ec414ece16f76c42b6655756fac6ac2c7af102ead44906fd46928f6521f7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ed54e378220b38eaa0fed336709b30870b5eb2f621ee0f88af0eca3422a64e78"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c8ece1d3f41636f6e5e3cbc78c6f7c649c228a13ff0f222ce770732291c9cedb"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/incus"

    generate_completions_from_executable(bin/"incus", shell_parameter_format: :cobra)
  end

  test do
    output = JSON.parse(shell_output("#{bin}/incus remote list --format json"))
    assert_equal "https://images.linuxcontainers.org", output["images"]["Addr"]

    assert_match version.to_s, shell_output("#{bin}/incus --version")
  end
end
