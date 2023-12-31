class Govc < Formula
  desc "Command-line tool for VMware vSphere"
  homepage "https://github.com/vmware/govmomi/tree/master/govc"
  url "https://github.com/vmware/govmomi/archive/refs/tags/v0.34.1.tar.gz"
  sha256 "bcddb44b974546da76db35d87756f6860aa0b210e3ca7e20e899bc6f25d200d9"
  license "Apache-2.0"

  # Upstream appears to use GitHub releases to indicate that a version is
  # released (and some tagged versions don't end up as a release), so it's
  # necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5424b385c391ae209c73be330435b257aca4a73eb65614600c59eae832cea19f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e76c5002285cb01f836c37b49720249047852661fd5a1f389f749f63eaf3db54"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "902c0fadbf439f3ac1c9f5d56ba256130b4ce90e6d0f075f89d3a58eb2098dcb"
    sha256 cellar: :any_skip_relocation, sonoma:         "01182851979c0e1c07973c5739301249a02f0d06c1e04a1bb8cdb40d38ad733a"
    sha256 cellar: :any_skip_relocation, ventura:        "6e20762ef617ca66dfba48e91ce88feeaaf8810dc9da9e6ce4b35db68d2ca48f"
    sha256 cellar: :any_skip_relocation, monterey:       "483b678ebe5ecce5856ff5ccb9032b52d28a1622345888518da7ef9ddc4a46b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3cd0cc71b4ac7cd63ec492e67cfd17cad8465096ec967adc62c532eac25ab769"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-o", "#{bin}/#{name}", "./#{name}"
  end

  test do
    assert_match "GOVC_URL=foo", shell_output("#{bin}/#{name} env -u=foo")
  end
end
