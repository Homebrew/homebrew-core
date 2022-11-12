class Nfpm < Formula
  desc "Simple deb and rpm packager"
  homepage "https://nfpm.goreleaser.com/"
  url "https://github.com/goreleaser/nfpm/archive/v2.22.0.tar.gz"
  sha256 "f8f4c049f09976622709deb5aa1f8b23e05f3616439b87c33900cb3f6f293d04"
  license "MIT"
  head "https://github.com/goreleaser/nfpm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "79d2a9b1f63cf94cd5bb80c4938b24e642ded58bcb956228fe2c8a8e53728c94"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e0b04870e16eb4c429667b35afd5db1210e988f0bf2e35d5f433eea1e40b594e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8d6f70f0060798074715921a71b2f69c4a27b0bcca3d3d78aecade78719f3f08"
    sha256 cellar: :any_skip_relocation, monterey:       "e77e7937b3eb7e2f9fb2a9a0baf46b290bec654049f20506e7abab56c4aa4dfd"
    sha256 cellar: :any_skip_relocation, big_sur:        "fe3ef9e36a804bdebf73786d108e234b1a9f2eb5af76e3096e5afe5cf4f523e6"
    sha256 cellar: :any_skip_relocation, catalina:       "cdc55dbca86013fb8dc66ce81247b79281ac50986c3c13382e7fe2b02ebb4c87"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1375747a11295c8597d1945d33ccd8e5962489c9470bcdffefd00803ec26054e"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=v#{version}"), "./cmd/nfpm"
  end

  test do
    assert_match version.to_s,
      shell_output("#{bin}/nfpm --version 2>&1")

    system bin/"nfpm", "init"
    assert_match "nfpm example config file", File.read(testpath/"nfpm.yaml")

    # remove the generated default one
    # and use stubbed one for another test
    File.delete(testpath/"nfpm.yaml")
    (testpath/"nfpm.yaml").write <<~EOS
      name: "foo"
      arch: "amd64"
      platform: "linux"
      version: "v1.0.0"
      section: "default"
      priority: "extra"
    EOS

    system bin/"nfpm", "pkg", "--packager", "deb", "--target", "."
    assert_predicate testpath/"foo_1.0.0_amd64.deb", :exist?
  end
end
