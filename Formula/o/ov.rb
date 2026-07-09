class Ov < Formula
  desc "Feature-rich terminal-based text viewer"
  homepage "https://noborus.github.io/ov/"
  url "https://github.com/noborus/ov/archive/refs/tags/v0.53.0.tar.gz"
  sha256 "b77dc59dc07738f5feb74c31c049f9d8731c71a51eb8687914a57c676aec467b"
  license "MIT"
  head "https://github.com/noborus/ov.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f861ca85d00ddb59a4913b3c861f34bae3ce36dc1cb1cc9f845196589d00be7c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f861ca85d00ddb59a4913b3c861f34bae3ce36dc1cb1cc9f845196589d00be7c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f861ca85d00ddb59a4913b3c861f34bae3ce36dc1cb1cc9f845196589d00be7c"
    sha256 cellar: :any_skip_relocation, sonoma:        "3280d7280ffa96af4216c417380b3f7ff47a00f77227165dda1da9580edbe86e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "beff1b32d331913d1cfb68ed300e3ce109f242fd276fda5905bedbef5f350b68"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9df3914c634a5230dbf1a4688d712a38c59ee9e482f2a30ae7d7dddb9ec7b89c"
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
