class Diffoci < Formula
  desc "Diff for Docker and OCI container images"
  homepage "https://github.com/reproducible-containers/diffoci"
  url "https://github.com/reproducible-containers/diffoci/archive/refs/tags/v0.1.4.tar.gz"
  sha256 "6baa31a25703bb70bc0de6640ac82f93abcba835df96a146a7456adf378b61cc"
  license "Apache-2.0"
  head "https://github.com/reproducible-containers/diffoci.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a1ffdfed56d2e050870055c282dd7a758535ea5974439a84f8d44af957e79dc2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a845d400415c5fe8d10caff547efd1772b8c7ea56d3f237c42430b9dc6b6af60"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5512f17901d3690a1fa006688e1dc5b98390ed1b35a39cad902d4ed42f7b4ef5"
    sha256 cellar: :any_skip_relocation, sonoma:         "5abe1a3dded720487f5fdfab7f6750a4d7d09932c0c26e978e4232fada96bb54"
    sha256 cellar: :any_skip_relocation, ventura:        "51edbfaedd5716512376e506de78073648edce7c9fd9033a5a39bf8ff31a9419"
    sha256 cellar: :any_skip_relocation, monterey:       "73f8dc64126696b74b6e18b125c46bb467069369f9a1767ff9200f7f64fa179d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f9358b6116bcb0dd04c68055fde85a51e02ef1d3c0ed1ed36a8763480e38e3ec"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/reproducible-containers/diffoci/cmd/diffoci/version.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/diffoci"

    generate_completions_from_executable(bin/"diffoci", "completion")
  end

  test do
    assert_match "Backend: local", shell_output("#{bin}/diffoci info")

    assert_match version.to_s, shell_output("#{bin}/diffoci --version")
  end
end
