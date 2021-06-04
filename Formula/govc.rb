class Govc < Formula
  desc "Command-line tool for VMware vSphere"
  homepage "https://github.com/vmware/govmomi/tree/master/govc"
  url "https://github.com/vmware/govmomi/archive/v0.26.0.tar.gz"
  sha256 "3b1b0aa46d7ce3d13be403d846bd50f366e91f6cadc42f64f11880fcb656dce4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "84c22738ef74e2d745d4ece493547074c2f3e6c5a32c3a0597c6ed89733a5e8c"
    sha256 cellar: :any_skip_relocation, big_sur:       "e227227b12c907f8c78d4682682db77779c2bfb198a0c30304ad07345701d058"
    sha256 cellar: :any_skip_relocation, catalina:      "30da7b9a4d22bab292dceb81a6d2fce17cfe8e0f398857da42eea150670d6b59"
    sha256 cellar: :any_skip_relocation, mojave:        "9fc6675cd73b3f08eefc0d6432b01be3035d2cf132352b3c4f9b4982318278e0"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-o", "#{bin}/#{name}", "./#{name}"
  end

  test do
    assert_match "GOVC_URL=foo", shell_output("#{bin}/#{name} env -u=foo")
  end
end
