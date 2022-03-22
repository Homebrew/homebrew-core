class Okteto < Formula
  desc "Build better apps by developing and testing code directly in Kubernetes"
  homepage "https://okteto.com"
  url "https://github.com/okteto/okteto/archive/2.0.0.tar.gz"
  sha256 "f5d9dbb07447a21a8b7b36ed81c165d9367a0bfda5183cb381e609b55448bc98"
  license "Apache-2.0"
  head "https://github.com/okteto/okteto.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "999baa0a72c1c0705d141325b664039d951576c591710a3ea748589068797649"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6d0b3a325f5a105006d304c02ecb11072cf67a526b49a1140ff1bddba3d1c139"
    sha256 cellar: :any_skip_relocation, monterey:       "53e6a7e0df3a13bd19fb0046bf846c1491f12b45a1d792ddaadbefffe4ea7604"
    sha256 cellar: :any_skip_relocation, big_sur:        "b1b6cb29a02043726d715931255cbcdef09e18c3a99dffe517909cbbc55eb902"
    sha256 cellar: :any_skip_relocation, catalina:       "c498244d45d83238aadb6d807deace8192df9455175896bd62407efd5e30f557"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e80e236b34a4fbc8752e2d2f150e903344bf7661fe83c5d9019f16b0acaeadc6"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/okteto/okteto/pkg/config.VersionString=#{version}"
    tags = "osusergo netgo static_build"
    system "go", "build", *std_go_args(ldflags: ldflags), "-tags", tags
  end

  test do
    assert_match "okteto version #{version}", shell_output("#{bin}/okteto version")

    assert_match "Please run 'okteto context' to select one context",
      shell_output(bin/"okteto init --context test 2>&1", 1)

    assert_match "No contexts are available.",
      shell_output(bin/"okteto context list 2>&1", 1)
  end
end
