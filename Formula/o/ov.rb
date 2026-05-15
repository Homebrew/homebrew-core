class Ov < Formula
  desc "Feature-rich terminal-based text viewer"
  homepage "https://noborus.github.io/ov/"
  url "https://github.com/noborus/ov/archive/refs/tags/v0.52.0.tar.gz"
  sha256 "0e119032077f14370e3dbf9eacd272e791784b9199e35b4abddc7bfe9f312ad4"
  license "MIT"
  head "https://github.com/noborus/ov.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "187741e6bac1eaf7bd979c193d88906c5235654f89306b6aca9af781deea8af4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "187741e6bac1eaf7bd979c193d88906c5235654f89306b6aca9af781deea8af4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "187741e6bac1eaf7bd979c193d88906c5235654f89306b6aca9af781deea8af4"
    sha256 cellar: :any_skip_relocation, sonoma:        "b315a58b6c67766879b46dc284ddf0e57f425a998b424bc73039a99b0f2d74e6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8a783c257e361fb9b70c99950f78d3c98c28258de3f3328ca89bea2db4ae74ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d802d740d0097ceaebfe1ad33a032ecbacd514985e5b3c417bf077dff43e659c"
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
