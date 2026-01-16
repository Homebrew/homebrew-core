class Godap < Formula
  desc "Complete TUI (terminal user interface) for LDAP"
  homepage "https://github.com/Macmod/godap"
  url "https://github.com/Macmod/godap/archive/refs/tags/v2.10.7.tar.gz"
  sha256 "5ca0c9b0220f9b30f42ffeddeee9fdf5e63feda55d3ed9d3f6dfdfd30da15f6d"
  license "MIT"
  head "https://github.com/Macmod/godap.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ec57d30d1e1d9e56b83b41007776c1242b3ad7847c2e6883e89888e6297ee34b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ec57d30d1e1d9e56b83b41007776c1242b3ad7847c2e6883e89888e6297ee34b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ec57d30d1e1d9e56b83b41007776c1242b3ad7847c2e6883e89888e6297ee34b"
    sha256 cellar: :any_skip_relocation, sonoma:        "f348129aca0b2d9029dadcb851a0cba84afc65ba6182f0360f0c1573b62e1814"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4802d15759c392dc4da01682e830ccbc07971e1568d0212a13aeedc257958c82"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "27fcd80069c66cb432a683f8b26076c550edcc63488fd39331fc76a7e2ae1483"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=#{version}")
    generate_completions_from_executable(bin/"godap",  shell_parameter_format: :cobra)
  end

  test do
    output = shell_output("#{bin}/godap -T 1 203.0.113.1 2>&1", 1)
    assert_match "LDAP Result Code 200 \"Network Error\": dial tcp 203.0.113.1:389: i/o timeout", output

    assert_match version.to_s, shell_output("#{bin}/godap version")
  end
end
