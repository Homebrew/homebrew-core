class Decompose < Formula
  desc "Reverse-engineering tool for docker environments"
  homepage "https://github.com/s0rg/decompose"
  url "https://github.com/s0rg/decompose/archive/refs/tags/v1.11.5.tar.gz"
  sha256 "1f2575d792bc5e04c57090534b871a9fac8b1f02a444beee76bf67a298f19090"
  license "MIT"
  head "https://github.com/s0rg/decompose.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e424bcddda5b1200be42ce59fcba05e78308a31d6d48ad6b9799672a9e3b6cc2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e424bcddda5b1200be42ce59fcba05e78308a31d6d48ad6b9799672a9e3b6cc2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e424bcddda5b1200be42ce59fcba05e78308a31d6d48ad6b9799672a9e3b6cc2"
    sha256 cellar: :any_skip_relocation, sonoma:        "0ef475c1f47feea38981477e905c87127065416859e8db2b8445a00f062bb738"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9bf094ca260f9a4782ccc4cb19de95defff7c9706df99e8f9d4ae76efb8dcd4d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9a277b280703412ce4157ede52547d5095ed81a683567a4418756bfc82da3ad4"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.GitTag=#{version} -X main.GitHash=#{tap.user} -X main.BuildDate=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/decompose"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/decompose -version")

    assert_match "Building graph", shell_output("#{bin}/decompose -local 2>&1", 1)
  end
end
