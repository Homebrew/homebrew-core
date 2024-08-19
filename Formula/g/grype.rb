class Grype < Formula
  desc "Vulnerability scanner for container images and filesystems"
  homepage "https://github.com/anchore/grype"
  url "https://github.com/anchore/grype/archive/refs/tags/v0.79.6.tar.gz"
  sha256 "c0dbbf14fcf58a0e09bc78fe329777aaac40ad0a07709129b440639459245221"
  license "Apache-2.0"
  head "https://github.com/anchore/grype.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6fff262ff2d707b677e22e79509d4ad839b22717ef97161aad3fe18f214237ce"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b6b4c991549cdfe7eeca402746c6a057c58f5ccba714c6f027e744d184ecfbc8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8afffeebf5323efa36ffab89e721c79e315b44e13eae253edabc745a567f72de"
    sha256 cellar: :any_skip_relocation, sonoma:         "6a434972365f1e174a932cdf7534ef6b0bd12ddea309922345fc2dc91e787a59"
    sha256 cellar: :any_skip_relocation, ventura:        "d9b601e6550a3e6d34cdf9d347c66363603e6f033adda51b9ddfdc8469cfdbe9"
    sha256 cellar: :any_skip_relocation, monterey:       "7989914452414dbe450c30f91ee9595a42f4b57097c81648a3f4c0672c4297ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "764d03890c36ee475c0dd54042c1a02766b7f5612dcb1e490e4cd0a728264474"
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
