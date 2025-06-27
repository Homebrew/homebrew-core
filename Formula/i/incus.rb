class Incus < Formula
  desc "CLI client for interacting with Incus"
  homepage "https://linuxcontainers.org/incus"
  url "https://linuxcontainers.org/downloads/incus/incus-6.14.tar.xz"
  sha256 "9a4392ab12e56e75440b0b88dfe6db1f96bd7b7050305e8cf135848d8af99c21"
  license "Apache-2.0"
  head "https://github.com/lxc/incus.git", branch: "main"

  livecheck do
    url "https://linuxcontainers.org/incus/downloads/"
    regex(/href=.*?incus[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3bdc48bce95df6d104b47f9ba711aa1c081f766ef4406cd3c08885a1cf1a4a37"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3bdc48bce95df6d104b47f9ba711aa1c081f766ef4406cd3c08885a1cf1a4a37"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3bdc48bce95df6d104b47f9ba711aa1c081f766ef4406cd3c08885a1cf1a4a37"
    sha256 cellar: :any_skip_relocation, sonoma:        "67e833805710c09473bc79af83e5edaeb8255ea06a3f88d50c332d11d9371bd1"
    sha256 cellar: :any_skip_relocation, ventura:       "67e833805710c09473bc79af83e5edaeb8255ea06a3f88d50c332d11d9371bd1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f101bb4910914279308ea2f986ad6198e41ed682e97e7f72b68714036a5f686b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "afff4caa5fa1ad78ef45457eaae66cf0c77e50cd9470d5803f6ab2855cc3015f"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/incus"

    generate_completions_from_executable(bin/"incus", "completion")
  end

  test do
    output = JSON.parse(shell_output("#{bin}/incus remote list --format json"))
    assert_equal "https://images.linuxcontainers.org", output["images"]["Addr"]

    assert_match version.to_s, shell_output("#{bin}/incus --version")
  end
end
