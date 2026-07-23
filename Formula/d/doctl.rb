class Doctl < Formula
  desc "Command-line tool for DigitalOcean"
  homepage "https://docs.digitalocean.com/reference/doctl/"
  url "https://github.com/digitalocean/doctl/archive/refs/tags/v1.164.0.tar.gz"
  sha256 "83ad66a22c3cb8193b36d1929fc9c980e3d2e796bbc63c841ade90d35f7cefce"
  license "Apache-2.0"
  head "https://github.com/digitalocean/doctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5689f035f0c98d09b418e45cbdc850db0c50992df363b1a12aece7a76f385948"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5689f035f0c98d09b418e45cbdc850db0c50992df363b1a12aece7a76f385948"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5689f035f0c98d09b418e45cbdc850db0c50992df363b1a12aece7a76f385948"
    sha256 cellar: :any_skip_relocation, sonoma:        "64ccefcc25e7885fde59703977106ca982e6bd49300f17a1ed9915b55df9a77c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a5e3840b6aa5312533d37049ee337a7dd7087ab364d8f5bcf719e57bb889bfe8"
    sha256 cellar: :any,                 x86_64_linux:  "957150f8fe8bccca70c92a73907d2fdde03b10040a0f1ea870d7ef349e407445"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/digitalocean/doctl.Major=#{version.major}
      -X github.com/digitalocean/doctl.Minor=#{version.minor}
      -X github.com/digitalocean/doctl.Patch=#{version.patch}
      -X github.com/digitalocean/doctl.Label=release
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/doctl"

    generate_completions_from_executable(bin/"doctl", shell_parameter_format: :cobra)
  end

  test do
    assert_match "doctl version #{version}-release", shell_output("#{bin}/doctl version")
  end
end
