class Incus < Formula
  desc "CLI client for interacting with Incus"
  homepage "https://linuxcontainers.org/incus"
  url "https://linuxcontainers.org/downloads/incus/incus-6.16.tar.xz"
  sha256 "ddbf3abf81c4a77cddeb0902d5e0e0471b83498d73db1a912e68f4ea71aa0850"
  license "Apache-2.0"
  head "https://github.com/lxc/incus.git", branch: "main"

  livecheck do
    url "https://linuxcontainers.org/incus/downloads/"
    regex(/href=.*?incus[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e24740cbd69e0c19f427ed2054a4f70dc2a6d3a115a584b558ce246cd912b9ab"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e24740cbd69e0c19f427ed2054a4f70dc2a6d3a115a584b558ce246cd912b9ab"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e24740cbd69e0c19f427ed2054a4f70dc2a6d3a115a584b558ce246cd912b9ab"
    sha256 cellar: :any_skip_relocation, sonoma:        "7b0ef91404bf7dd3d7ad2399e2542db6e525281324aa2a7ba9c4dce6cf82d1a1"
    sha256 cellar: :any_skip_relocation, ventura:       "7b0ef91404bf7dd3d7ad2399e2542db6e525281324aa2a7ba9c4dce6cf82d1a1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a1e880760e2e03249e47a61386f5b380cd0aca78df716ae550b0eb2f7560603b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d92541b8bce83ea9621af051ce04b7ba4958fd8f7ad5d40d4116a510c6f0ff8d"
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
