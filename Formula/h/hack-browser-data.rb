class HackBrowserData < Formula
  desc "Command-line tool for decrypting and exporting browser data"
  homepage "https://github.com/moonD4rk/HackBrowserData"
  url "https://github.com/moonD4rk/HackBrowserData/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "f856385687f87bd7f099d3d431289a012d64b2ede719b2b72453934f3be11b86"
  license "MIT"
  head "https://github.com/moonD4rk/HackBrowserData.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5188d7ce62d6e242674c9beda55f0761119f4e194efcea286b50e04a389e81f8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5188d7ce62d6e242674c9beda55f0761119f4e194efcea286b50e04a389e81f8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5188d7ce62d6e242674c9beda55f0761119f4e194efcea286b50e04a389e81f8"
    sha256 cellar: :any_skip_relocation, sonoma:        "1309e377866a7e547fd7ae93e741a4ff35046e718c49f77ccb492044607bd274"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "07c94a19af17db62aae7fc059d15254585dd80f0430b3681f883c4f541c52519"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2cf67f50372cfd85f81c5807b6da827e78c9e38fbec746b595ac85fa90c505f1"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{tap.user}
      -X main.buildDate=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/hack-browser-data"

    generate_completions_from_executable(bin/"hack-browser-data", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hack-browser-data version")

    output = shell_output("#{bin}/hack-browser-data -b chrome -f json --dir #{testpath}/results 2>&1")
    assert_match "[WRN] no browsers found\n", output
  end
end
