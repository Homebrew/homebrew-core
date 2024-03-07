class Grype < Formula
  desc "Vulnerability scanner for container images and filesystems"
  homepage "https://github.com/anchore/grype"
  url "https://github.com/anchore/grype/archive/refs/tags/v0.74.7.tar.gz"
  sha256 "3a94ff42cd68a28638e30b87ae7c5216fdafb2b2f6239498cd0b49c942c1353c"
  license "Apache-2.0"
  head "https://github.com/anchore/grype.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bf04bf245fbc0bf06d60bfe91ddf201011847537e3da22960ebac7174683d213"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "febc00ecdc2ff21ab6247699a18e1e1cdc1940fc21918d506e16504aea25502b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "06538809b0a2ff37a3894be58532d8ab736fcdfb3e1ac788886baeac3d3f3e08"
    sha256 cellar: :any_skip_relocation, sonoma:         "51b8d56f2b7d5d3140a74d614b0d192dbeae354bd8895600b1288d5adc8b9fd2"
    sha256 cellar: :any_skip_relocation, ventura:        "e406df91ac12f4db602375c499ea95e58f8ceb4f95a7e55c04ef9528b8dadb25"
    sha256 cellar: :any_skip_relocation, monterey:       "108029942b4d7ebaaef189cf51b4442bfcacb578903e06c979910e7ed77122ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a9c84883e209f51c2456df053c6deb1883ff7ae212f48c3898483ed99be29d32"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.gitCommit=brew
      -X main.buildDate=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/grype"

    generate_completions_from_executable(bin/"grype", "completion")
  end

  test do
    assert_match "database metadata not found", shell_output("#{bin}/grype db status 2>&1", 1)
    assert_match "Update available", shell_output("#{bin}/grype db check", 100)
    assert_match version.to_s, shell_output("#{bin}/grype version 2>&1")
  end
end
