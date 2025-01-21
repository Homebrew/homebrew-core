class Grype < Formula
  desc "Vulnerability scanner for container images and filesystems"
  homepage "https://github.com/anchore/grype"
  url "https://github.com/anchore/grype/archive/refs/tags/v0.86.1.tar.gz"
  sha256 "d339067ba687e70bf62b6050c40d89bf9217ac33e8c101744393d61a4c0e0fb1"
  license "Apache-2.0"
  head "https://github.com/anchore/grype.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "273577042dbb0b4d5857715271fb6c5a586baeb06d5a88920f0cdfa5de7917f2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c7dec8df8068443f18583914df0cf9fb3586e431c3dd915627f5a80b305aff23"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ac243acae4189c0650057182ab520e6a6f7126bec3a6d44748795798f694a437"
    sha256 cellar: :any_skip_relocation, sonoma:        "8e7b468876ee68803757aa026358e874cf7c9fcf10a188fac68f20ec92c53697"
    sha256 cellar: :any_skip_relocation, ventura:       "3b81b9d43b2c2270830be61529a918dfc119b648f4225008d1e58809765530a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d4b833a7cedca7883ff7a25de0bbca459ff5083363e423b9b8bc3f5a66395fca"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.gitCommit=#{tap.user} -X main.buildDate=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/grype"

    generate_completions_from_executable(bin/"grype", "completion")
  end

  test do
    assert_match "database metadata not found", shell_output("#{bin}/grype db status 2>&1", 1)
    assert_match "update to the latest db", shell_output("#{bin}/grype db check", 100)
    assert_match version.to_s, shell_output("#{bin}/grype version 2>&1")
  end
end
