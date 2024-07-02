class Grype < Formula
  desc "Vulnerability scanner for container images and filesystems"
  homepage "https://github.com/anchore/grype"
  url "https://github.com/anchore/grype/archive/refs/tags/v0.79.2.tar.gz"
  sha256 "cc6bda73ef23473425370ed4d8fcb98e6729790999cc81d66a815b379141b5a0"
  license "Apache-2.0"
  head "https://github.com/anchore/grype.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f220d386a17be3f5adefc59dd4e4260da1d338e64a4afede7b9ca7bc26c4c737"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "60bf2c50413b661b4b2a91b6680218637fee1f4fe880a95577be136c0c7761e0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "13b1e40b7b4ddc4e439996b3adf001ba630641d72b0aa44016b1b798102cfd21"
    sha256 cellar: :any_skip_relocation, sonoma:         "4775694136989bff5d92bc5c104e3d7089450be1e1650c654f0a25f06b1364f1"
    sha256 cellar: :any_skip_relocation, ventura:        "4c7a96cdea5b4dd912878045413bdf97beff2436c0d772fbb3b495329f0efc15"
    sha256 cellar: :any_skip_relocation, monterey:       "749a356209296f3b1a77a687ded4a33afe6176f3b0bea9dab8e8d25f3e97e14b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ff5ee9be13500415616a08322276be47fd02a95dabbdadc0c922808ad43ef3ad"
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
