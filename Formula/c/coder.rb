class Coder < Formula
  desc "Tool for provisioning self-hosted development environments with Terraform"
  homepage "https://coder.com"
  url "https://github.com/coder/coder/archive/refs/tags/v2.27.8.tar.gz"
  sha256 "9d95feb6fc640076f2c5114e9bb1617e8c0261970d1d1f9a00bc933d855112df"
  license "AGPL-3.0-only"
  head "https://github.com/coder/coder.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "19d423666d6b4ddcccc15e1728b609047a1cc06d918235466f4baa9708d2827b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0865eefea0f1e8f146e961c8b4f224bc831dc5426f16e3c1cfe991c6cd553369"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d498c43b179affa394788021a00698e28f543893c67edf3bb6b67a7012b9c779"
    sha256 cellar: :any_skip_relocation, sonoma:        "f1d207510ad1e1705ebacfce82c7cd9f9ac4117a1936ee12ab5614e52972b4c0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "94822399f6f4d0b2372954f4fcf260529cd29d354e937e90736fd491a16398b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2b10416793e26b16215fc5284e60ba25e9f64d45beacc54f99af298d0c7c370f"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/coder/coder/v2/buildinfo.tag=#{version}
      -X github.com/coder/coder/v2/buildinfo.agpl=true
    ]
    system "go", "build", *std_go_args(ldflags:, tags: "slim"), "./cmd/coder"
  end

  test do
    version_output = shell_output("#{bin}/coder version")
    assert_match version.to_s, version_output
    assert_match "AGPL", version_output
    assert_match "Slim build", version_output

    assert_match "You are not logged in", shell_output("#{bin}/coder netcheck 2>&1", 1)
  end
end
