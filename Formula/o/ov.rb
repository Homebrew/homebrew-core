class Ov < Formula
  desc "Feature-rich terminal-based text viewer"
  homepage "https://noborus.github.io/ov/"
  url "https://github.com/noborus/ov/archive/refs/tags/v0.51.1.tar.gz"
  sha256 "740d018007e7da96787c057261e5a239513754102d1ad34d196e028221de0797"
  license "MIT"
  head "https://github.com/noborus/ov.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "430c33fb58bcd28bdfaed3f0792547949b66037d0e3ccfb7910be765c48aeb04"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "430c33fb58bcd28bdfaed3f0792547949b66037d0e3ccfb7910be765c48aeb04"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "430c33fb58bcd28bdfaed3f0792547949b66037d0e3ccfb7910be765c48aeb04"
    sha256 cellar: :any_skip_relocation, sonoma:        "acd705415344b94a3350b86defebabc832066ee385eec8753e12d60fba3d86f3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "424dad4fd89ce7f62c0dbbe9f86bfdca02f7d5427aa6e66296f777ca07a5e748"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8be500c3309ff5f9dde08f2279ffdcaa97ceae14bcfb207e2c965b1f6b584bfb"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.Version=#{version} -X main.Revision=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"ov", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ov --version")

    (testpath/"test.txt").write("Hello, world!")
    assert_match "Hello, world!", shell_output("#{bin}/ov test.txt")
  end
end
