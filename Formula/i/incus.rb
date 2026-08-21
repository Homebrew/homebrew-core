class Incus < Formula
  desc "CLI client for interacting with Incus"
  homepage "https://linuxcontainers.org/incus"
  url "https://linuxcontainers.org/downloads/incus/incus-7.3.tar.xz"
  sha256 "00a2aa2aa68d64c198e9118797bc042f7d9bbf2dea76a804fb8e5496918b413c"
  license "Apache-2.0"
  head "https://github.com/lxc/incus.git", branch: "main"

  livecheck do
    url "https://linuxcontainers.org/incus/downloads/"
    regex(/href=.*?incus[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "efec142ec8c5ab4812185c727ca6ff97792000a8a0a88b3c31d2be29cfd83065"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "efec142ec8c5ab4812185c727ca6ff97792000a8a0a88b3c31d2be29cfd83065"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "efec142ec8c5ab4812185c727ca6ff97792000a8a0a88b3c31d2be29cfd83065"
    sha256 cellar: :any_skip_relocation, sonoma:        "a16e81ef53a91f1dfbdc1ce8608771ab1e090d41c4bb38d8578a58ce392d4066"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "312a5429282b689578e2702d656fd6229a08edde014cb2b498c402ae2693799a"
    sha256 cellar: :any,                 x86_64_linux:  "84b9b08146ec3817e287b2f95ce16edfb2e7d847f1d3a8aedf75b4a166523fca"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./cmd/incus"

    generate_completions_from_executable(bin/"incus", shell_parameter_format: :cobra)
  end

  test do
    output = JSON.parse(shell_output("#{bin}/incus remote list --format json"))
    assert_equal "https://images.linuxcontainers.org", output["images"]["Addrs"][0]

    assert_match version.to_s, shell_output("#{bin}/incus --version")
  end
end
