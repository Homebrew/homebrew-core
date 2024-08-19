class Incus < Formula
  desc "CLI client for interacting with Incus"
  homepage "https://linuxcontainers.org/incus"
  url "https://linuxcontainers.org/downloads/incus/incus-6.4.tar.xz"
  sha256 "6748a61f4a066bcd807c38ca13693f7ede1903d9b44825f1b5bcea4220edeee7"
  license "Apache-2.0"
  head "https://github.com/lxc/incus.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "affea1aa6fa333b8747d8da638d54f556c7ca2a13e2e081b7e2b15377461fcaf"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "41f957202168d241ea4656e9be73d56dc5c6b789e14f8fc1ffcc74f70b5fb581"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1762d102c0ff819710110752b8b91b201faaedbf89fe634a204907fc8fd4e8f2"
    sha256 cellar: :any_skip_relocation, sonoma:         "34c93b2706cbcc9e28456f27638d488aed652b893a10094a37f534945790f5c8"
    sha256 cellar: :any_skip_relocation, ventura:        "2b665f97c57e67f1e213a14f5d8076140146b0128bcc476afd6340f7d0490f8e"
    sha256 cellar: :any_skip_relocation, monterey:       "65e79f37b8e90a42792a0cdcb44b9a6e2ed9d7ff49f11771b8d7688dfaa7c18b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4eaa482d6ccfbfecb3869e10fb0be5fa2ec2d032bfb3e859b2e3301517e9cdaa"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/incus"
  end

  test do
    output = JSON.parse(shell_output("#{bin}/incus remote list --format json"))
    assert_equal "https://images.linuxcontainers.org", output["images"]["Addr"]

    assert_match version.to_s, shell_output("#{bin}/incus --version")
  end
end
