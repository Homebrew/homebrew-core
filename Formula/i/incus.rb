class Incus < Formula
  desc "CLI client for interacting with Incus"
  homepage "https://linuxcontainers.org/incus"
  url "https://linuxcontainers.org/downloads/incus/incus-6.19.1.tar.xz"
  sha256 "a3f513e988a6b1c38182478d57f5e60dc6c7331217d22c05a73de33baa553de8"
  license "Apache-2.0"
  head "https://github.com/lxc/incus.git", branch: "main"

  livecheck do
    url "https://linuxcontainers.org/incus/downloads/"
    regex(/href=.*?incus[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "81bb8f45fe95b23d5436b1ceb4aaab7f3f3e74f9950964e2688fc08b246e8f0c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "81bb8f45fe95b23d5436b1ceb4aaab7f3f3e74f9950964e2688fc08b246e8f0c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "81bb8f45fe95b23d5436b1ceb4aaab7f3f3e74f9950964e2688fc08b246e8f0c"
    sha256 cellar: :any_skip_relocation, sonoma:        "0e2e6cbf0c8e0a56ec89ded6f24a54bad8a881d1e4307ba5f591904de700b4c9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a5a2a2013baa11a21d4f424a35fb3c0e4a7c2010d30927eaeb0174deb6dde4a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b02f2c7b9959280abe42747068cd40cae8332adac63ff444caf3e4847f30e55a"
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
