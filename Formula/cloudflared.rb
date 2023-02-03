class Cloudflared < Formula
  desc "Cloudflare Tunnel client (formerly Argo Tunnel)"
  homepage "https://developers.cloudflare.com/cloudflare-one/connections/connect-apps/install-and-setup/tunnel-guide"
  url "https://github.com/cloudflare/cloudflared/archive/refs/tags/2023.2.1.tar.gz"
  sha256 "468b0953eca6ab189859073067857062c91ed9adb18e12a43527e0dba3aa6409"
  license "Apache-2.0"
  head "https://github.com/cloudflare/cloudflared.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5bab313459270795e88f66ba170b8a7b43bdfd2b76117c1023b9b544cdaf046e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "300be568aa3a35f5107d33cd1993069d2baf39a8a3b6fd6dae78e51a1efb180c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e8926cd831109524a384c8d84e1286b663e1d8a47955a300d632ba8745539982"
    sha256 cellar: :any_skip_relocation, ventura:        "125ef471626a74e3e12c162359f3530eb307f43a8210f3c065f4bab640674010"
    sha256 cellar: :any_skip_relocation, monterey:       "b005671fce5bc22ea8db0613c7942a1244b5915018fe6b07be5ed926d97d6eb9"
    sha256 cellar: :any_skip_relocation, big_sur:        "3f68da18bd5b68adf0f214bf757bb4ea7427e7d635c209b2d2374d3ef652d337"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "af03d95d243379cbcdae21e798e5ba71d0efb9b52adcb08cb664fc18f3152cb0"
  end

  depends_on "go" => :build

  def install
    system "make", "install",
      "VERSION=#{version}",
      "DATE=#{time.iso8601}",
      "PACKAGE_MANAGER=#{tap.user}",
      "PREFIX=#{prefix}"
  end

  test do
    help_output = shell_output("#{bin}/cloudflared help")
    assert_match "cloudflared - Cloudflare's command-line tool and agent", help_output
    assert_match version.to_s, help_output
    assert_equal "unable to find config file\n", shell_output("#{bin}/cloudflared 2>&1", 1)
    assert_match "Error locating origin cert", shell_output("#{bin}/cloudflared tunnel run abcd 2>&1", 1)
    assert_match "cloudflared was installed by #{tap.user}. Please update using the same method.",
      shell_output("#{bin}/cloudflared update 2>&1")
  end
end
