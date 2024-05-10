class Grype < Formula
  desc "Vulnerability scanner for container images and filesystems"
  homepage "https://github.com/anchore/grype"
  url "https://github.com/anchore/grype/archive/refs/tags/v0.77.4.tar.gz"
  sha256 "c95abb1ebd70d10708a8971f3c9211697e1413afa8b139e72832f40c018c4bff"
  license "Apache-2.0"
  head "https://github.com/anchore/grype.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3314f86ed0e4bd45ca577d35b44e320a815d06ccb9b317a5641a66e3bb7493b7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ede0842ca467c835570b11a9f731d63de10fe25dec527ac888a977ee11502207"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eedc0d5d661f78f69c1491bca304667c5d632d496c74017f4582d90f0c0f8ef3"
    sha256 cellar: :any_skip_relocation, sonoma:         "47ae7c20ae4089bcbe7efa553495841bae36323fd72d5466105baf943cd0e13a"
    sha256 cellar: :any_skip_relocation, ventura:        "9aa8e93296d8e606b673827ee5e66e39de3dd8c93cf1e6a7653a1fd138c80cdc"
    sha256 cellar: :any_skip_relocation, monterey:       "b400ae4535ad5b88bfe52dc35c21fcd0b210a23e8b6ac65752ca85c5867174ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b9f4df3718ea555455835ac6f10b22ba60fc14ba464e9d53d049a61b55cd2ae8"
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
