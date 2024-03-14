class Nuclei < Formula
  desc "HTTP/DNS scanner configurable via YAML templates"
  homepage "https://nuclei.projectdiscovery.io/"
  url "https://github.com/projectdiscovery/nuclei/archive/refs/tags/v3.2.0.tar.gz"
  sha256 "050c39d5e4e650d42d53c5d5a3136a3ce3f2570eca0bd40f4ce1f43ee89b34c7"
  license "MIT"
  head "https://github.com/projectdiscovery/nuclei.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c21e63f7f201843bef88b83ee99fa086191167faefb82c9f03b5fd280b30f952"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6c0eccc8a3588e5da08f71c20edf1bc5e2fdac12061d1225ea9b4c0954550d66"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2d4c8cf26de5829d890ad93764d6c5c89caa2894c11223bbe5a73fe6dec7ba73"
    sha256 cellar: :any_skip_relocation, sonoma:         "537eb306f324d047cfe311633aacc195e18b195199bd66535c7b34620b655055"
    sha256 cellar: :any_skip_relocation, ventura:        "e5aa21f30ac90e7aaab308f84e0274eb748586e697e0d1bd9733ec5e04a49f49"
    sha256 cellar: :any_skip_relocation, monterey:       "aaa3cfb51ecf3d3cce391eb61340ed8cafd17f7a0b36606733bb4a9078b1e4f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0b03836e955471b4b92c4aa9d10c31d4c35a85aa5afcc9ff8156341ef98fdb9c"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/nuclei"
  end

  test do
    output = shell_output("#{bin}/nuclei -scan-all-ips -disable-update-check example.com 2>&1", 1)
    assert_match "No results found", output

    assert_match version.to_s, shell_output("#{bin}/nuclei -version 2>&1")
  end
end
