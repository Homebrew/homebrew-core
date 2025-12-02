class Bomber < Formula
  desc "Scans Software Bill of Materials for security vulnerabilities"
  homepage "https://github.com/devops-kung-fu/bomber"
  url "https://github.com/devops-kung-fu/bomber/archive/refs/tags/v0.5.1.tar.gz"
  sha256 "f4d8165ea9d3be0e88fdb33d35870588df308f31a4c40f14f09f0b68570f6ae1"
  license "MPL-2.0"
  head "https://github.com/devops-kung-fu/bomber.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "746c9ea4e2f8e3c20774f9b9f587d6efc5611b9ec93483b076f1158fdbfd9b06"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "989ad14e281150f655296b8aa8ca9a3d24965bbd690d9ce8db45163e92429004"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "989ad14e281150f655296b8aa8ca9a3d24965bbd690d9ce8db45163e92429004"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "989ad14e281150f655296b8aa8ca9a3d24965bbd690d9ce8db45163e92429004"
    sha256 cellar: :any_skip_relocation, sonoma:        "ebe873ca7a04da1270598e2067be206460afa6d3779582773fc60e1529a3386c"
    sha256 cellar: :any_skip_relocation, ventura:       "ebe873ca7a04da1270598e2067be206460afa6d3779582773fc60e1529a3386c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4990cf29a0f9a505ce0521327e90670810d2d62a8168cd18cc02f787c4f2f057"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "59deb5d9be3344d651aeaa337219f5183857dcb09e1b460788f3549e57bc6d0d"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"bomber", "completion")

    pkgshare.install "_TESTDATA_"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/bomber --version")

    cp pkgshare/"_TESTDATA_/sbom/bomber.spdx.json", testpath
    output = shell_output("#{bin}/bomber scan bomber.spdx.json")
    assert_match "Total vulnerabilities found:", output
  end
end
