class Kaf < Formula
  desc "Modern CLI for Apache Kafka"
  homepage "https://github.com/birdayz/kaf"
  url "https://github.com/birdayz/kaf/archive/refs/tags/v0.2.14.tar.gz"
  sha256 "83e78c19e5bce2d1922910809c19bacf489f6d16bbabefa6dcdd3e4b5c292b13"
  license "Apache-2.0"
  head "https://github.com/birdayz/kaf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ca55afe9d549bc18b12c10c6df7789996d411ce1ca0a5ed34ce7df422dc0d3f8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ca55afe9d549bc18b12c10c6df7789996d411ce1ca0a5ed34ce7df422dc0d3f8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ca55afe9d549bc18b12c10c6df7789996d411ce1ca0a5ed34ce7df422dc0d3f8"
    sha256 cellar: :any_skip_relocation, sonoma:        "bd74e7cc23e0868a5cd22aa2531b47d990067477b85d630bccbdba70594e238a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7cc88b6d60e64066ca9558378b9337937d96f609d532b5aca5e822078b0805df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3d8d96547b6a6125b3af63f366c78bcc8cba07c81760683547505dd5a0e61f73"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=Homebrew"
    system "go", "build", *std_go_args(ldflags:), "./cmd/kaf"

    generate_completions_from_executable(bin/"kaf", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kaf --version")

    system bin/"kaf", "config", "add-cluster", "local", "-b", "localhost:9092"
    system bin/"kaf", "config", "use-cluster", "local"
    assert_equal "local\n", shell_output("#{bin}/kaf config current-context")
  end
end
