class Naabu < Formula
  desc "Fast port scanner"
  homepage "https://docs.projectdiscovery.io/tools/naabu/overview"
  url "https://github.com/projectdiscovery/naabu/archive/refs/tags/v2.3.4.tar.gz"
  sha256 "51f2bb5d00b5951798973b578eec3a2e353c76da22a29844dab27d7f01baabd8"
  license "MIT"
  head "https://github.com/projectdiscovery/naabu.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "afe496cdde964c4e1af352070b5dd5c39d5be1472f5c0eb6a0285195740ea745"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fe12a077d5686f65488fb0d0f767f4435ec1fb77eb36e4b98eae763d6e147cd8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0e37e1203f18e2a403ee4013180b52948c1c1d81faaee2e85681f6e364f1c353"
    sha256 cellar: :any_skip_relocation, sonoma:        "e1c3e6145fe672066ef1ad60dc764610c775c5596adce6df632346238d42f5f4"
    sha256 cellar: :any_skip_relocation, ventura:       "905d018934cb185e075e2016f78cb51bbd0c8ae1ae6105e625d22a8c9bb4dd37"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a55af6311bc0b3cb436b0e44a9df8b3a10708585b0a599830cb9662673693665"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "75c58e20514c22dfccb43653c25566d8ea71d411d3e606184ae54132c817bd1d"
  end

  depends_on "go" => :build

  uses_from_macos "libpcap"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/naabu"
  end

  test do
    assert_match "brew.sh:443", shell_output("#{bin}/naabu -host brew.sh -p 443")

    assert_match version.to_s, shell_output("#{bin}/naabu --version 2>&1")
  end
end
