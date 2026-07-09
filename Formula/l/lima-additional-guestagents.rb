class LimaAdditionalGuestagents < Formula
  desc "Additional guest agents for Lima"
  homepage "https://lima-vm.io/"
  url "https://github.com/lima-vm/lima/archive/refs/tags/v2.1.4.tar.gz"
  sha256 "39209f4f573fc753aea3e95f52713a6432f32f73da5bb60ba913ca46edb1924c"
  license "Apache-2.0"
  head "https://github.com/lima-vm/lima.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f505040bd50d13ad0dc55790507a3893db22d09a36dec3b950de9cec64b56108"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "676cb671cb93733370853c60846959009b42955a71c2884dad284f20e08fb9eb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "97422f9393161fad6614bef1b5afad1475ec101344c2715cc0167f1a1f7624cf"
    sha256 cellar: :any_skip_relocation, sonoma:        "b4dbc60e0824f4879d35a83bc8a4496803aace07461afcb1d9ba32275ac2ad67"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b8c5e9fc2b703064112ab5d8bfe7345f6f7acb4dc88213e98a28a012afb90618"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5c5944968de7a3c6e4bb256a6cf3049ed6327f101e30f4e1cac725a2034f14dd"
  end

  depends_on "go" => :build
  depends_on "lima"
  depends_on "qemu"

  def install
    if build.head?
      system "make", "additional-guestagents"
    else
      # VERSION has to be explicitly specified when building from tar.gz, as it does not contain git tags
      system "make", "additional-guestagents", "VERSION=#{version}"
    end

    bin.install Dir["_output/bin/*"]
    share.install Dir["_output/share/*"]
  end

  test do
    info = JSON.parse shell_output("limactl info")
    assert_includes info["guestAgents"], "riscv64"
  end
end
