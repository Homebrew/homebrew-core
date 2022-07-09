class KtConnect < Formula
  desc "Toolkit for integrating with kubernetes dev environment more efficiently"
  homepage "https://alibaba.github.io/kt-connect"
  url "https://github.com/alibaba/kt-connect/archive/refs/tags/v0.3.6.tar.gz"
  sha256 "c29d4d9a18defdd8485adfe3a75b2887b42544fedd404073844629666bb28c9f"
  license "GPL-3.0-or-later"
  head "https://github.com/alibaba/kt-connect.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5492c3e9ce0c5b6539ab48ce75d4fcceae1da8c2ff3c5997481582580bf34673"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e023697e0f3c07897d0f189d333aff8306b1d1873f1ed4f3c41ebd46954c5129"
    sha256 cellar: :any_skip_relocation, monterey:       "475aff303eabcfcf387e759c6ec771a7aadefd81a9e1e7bbc813ee7a7d2f737b"
    sha256 cellar: :any_skip_relocation, big_sur:        "aaaf22ea7dbdf9c691f67739f305add40401b90d703c0b09b1db021a4fe88f3a"
    sha256 cellar: :any_skip_relocation, catalina:       "3a5caacb691fca4e4f88cc221ad9a99af2bb2af6125b06f9ba8bf28c6d69b551"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bb4ca1617b030781a5a9e50f3dfc2e343f5f7a6254b34f1a6ea0546e10c1e700"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags, output: bin/"ktctl"), "./cmd/ktctl"

    # Install bash completion
    output = Utils.safe_popen_read(bin/"ktctl", "completion", "bash")
    (bash_completion/"ktctl").write output

    # Install zsh completion
    output = Utils.safe_popen_read(bin/"ktctl", "completion", "zsh")
    (zsh_completion/"_ktctl").write output

    # Install fish completion
    output = Utils.safe_popen_read(bin/"ktctl", "completion", "fish")
    (fish_completion/"ktctl.fish").write output
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ktctl --version")
    # Should error out as exchange require a service name
    assert_match "name of service to exchange is required", shell_output("#{bin}/ktctl exchange 2>&1")
  end
end
