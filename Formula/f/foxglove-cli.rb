class FoxgloveCli < Formula
  desc "Foxglove command-line tool"
  homepage "https://github.com/foxglove/foxglove-cli"
  url "https://github.com/foxglove/foxglove-cli/archive/refs/tags/v1.0.26.tar.gz"
  sha256 "86429da79e8108e827cb2ad66dc3c5aac84229b691dc7b171db08b5acb3a35c2"
  license "MIT"
  head "https://github.com/foxglove/foxglove-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d5947bdf3f815829b9c16782cda41050a16e5b5b79efc843cf771217dec19530"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "754ee2e063bf53f94466cf4b33b6cd14ffa887f6be0fe78e82929c7afa821405"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "908a0d7f62d3538a13b1e189b0145e8d1e53585bbc0674f4cc41e260b9b73ed4"
    sha256 cellar: :any_skip_relocation, sonoma:        "d2bc35698d135838ce1049592c0ed0d0bbe89a53360c4da35ea0f398bfdc816b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "479da886a75377081092d874711b6ae2691877fd19aa415820f9d26dfeb8e0cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1e70572bf5d9c4769a482d395e57928ec1d1111a52ff010a0c6d31a3a5099112"
  end

  depends_on "go" => :build

  def install
    cd "foxglove" do
      system "make", "build", "VERSION=v#{version}"
      bin.install "foxglove"
    end
  end

  test do
    system bin/"foxglove", "auth", "configure-api-key", "--api-key", "foobar"
    expected = "Authenticated with API key"
    assert_match expected, shell_output("#{bin}/foxglove auth info")
    assert_match version.to_s, shell_output("#{bin}/foxglove version")
  end
end
