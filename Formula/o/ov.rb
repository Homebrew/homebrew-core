class Ov < Formula
  desc "Feature-rich terminal-based text viewer"
  homepage "https://noborus.github.io/ov/"
  url "https://github.com/noborus/ov/archive/refs/tags/v0.41.0.tar.gz"
  sha256 "5c3997c02770ff12e51abaabb60629869692653ae4ee5e5a015f3f28c070b48d"
  license "MIT"
  head "https://github.com/noborus/ov.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "852ebaf323e65667877febffb2bd7db3c62593dd70d31d2e91a6b405011d5b31"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "852ebaf323e65667877febffb2bd7db3c62593dd70d31d2e91a6b405011d5b31"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "852ebaf323e65667877febffb2bd7db3c62593dd70d31d2e91a6b405011d5b31"
    sha256 cellar: :any_skip_relocation, sonoma:        "46c6f4f5673168790ef28b34fc7f796a3eba3fdd4bc3046bb505d7b2d055e556"
    sha256 cellar: :any_skip_relocation, ventura:       "46c6f4f5673168790ef28b34fc7f796a3eba3fdd4bc3046bb505d7b2d055e556"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2bfd9460de79d868cf5821be230eee996b6910fdf997dec955dc0501e6464496"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.Version=#{version} -X main.Revision=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ov --version")

    (testpath/"test.txt").write("Hello, world!")
    assert_match "Hello, world!", shell_output("#{bin}/ov test.txt")
  end
end
