class Govc < Formula
  desc "Command-line tool for VMware vSphere"
  homepage "https://github.com/vmware/govmomi/tree/master/govc"
  url "https://github.com/vmware/govmomi/archive/refs/tags/v0.37.1.tar.gz"
  sha256 "4043ca748d58c76c536289d0647282ad49c533ff43566c16b07275869a55833d"
  license "Apache-2.0"

  # Upstream appears to use GitHub releases to indicate that a version is
  # released (and some tagged versions don't end up as a release), so it's
  # necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b7875bb4da6086934219a84cd2a66e24d12189536c4813282d55deac6a7fa53b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "207ea57603d39bf008e2d05c09f1b90a188388bfc1aa30c4ae27589fef83782a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c7e96ebee4aec42507814f92a80375fee03100b310a92df53df1f22659620b71"
    sha256 cellar: :any_skip_relocation, sonoma:         "8a14768f3fb566be185e3d19db217cd55216c9b82e707d5df70f981462b68bd8"
    sha256 cellar: :any_skip_relocation, ventura:        "b31f249baab21a3d56be5dda25b160f692c1939dc3578d18df067a2183d4c271"
    sha256 cellar: :any_skip_relocation, monterey:       "ea15b7e23f6e1bb7c9313e5b332a231c00ea1a3a527683f57729c91a6ca9a514"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "83b1d7af2dd8fd75f4b1e349db4fb2b08755a663c1dc152e0d3fb9df64f2e31b"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-o", "#{bin}/#{name}", "./#{name}"
  end

  test do
    assert_match "GOVC_URL=foo", shell_output("#{bin}/#{name} env -u=foo")
  end
end
