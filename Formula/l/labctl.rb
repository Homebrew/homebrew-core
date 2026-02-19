class Labctl < Formula
  desc "CLI tool for interacting with iximiuz labs and playgrounds"
  homepage "https://github.com/iximiuz/labctl"
  url "https://github.com/iximiuz/labctl/archive/refs/tags/v0.1.58.tar.gz"
  sha256 "ea298f2ccadf3cf0c4b154e9d1161f430b7e4ed967e753269e1e08c83deb2f58"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dd1d05aa4486c4f7af4357579cd3c0e70e74413e4d0d554941344920d5182d7d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dd1d05aa4486c4f7af4357579cd3c0e70e74413e4d0d554941344920d5182d7d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dd1d05aa4486c4f7af4357579cd3c0e70e74413e4d0d554941344920d5182d7d"
    sha256 cellar: :any_skip_relocation, sonoma:        "ef08382c29ef6774b50cbbbdb92ba338e57d1c305ed6b7e0676c942e7f3fb7a9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "80e1d2d6f31f39e0327ed18444121f16358df4aba552993cc5193505bd83fedd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "664169da5f0f99ed9f3e3b9062801406a07f2efcc395f186cd14846402b69681"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{tap.user}
      -X main.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/labctl --version")

    assert_match "Not logged in.", shell_output("#{bin}/labctl auth whoami 2>&1")
    assert_match "authentication required.", shell_output("#{bin}/labctl playground list 2>&1", 1)
  end
end
