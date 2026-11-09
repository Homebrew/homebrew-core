class Grype < Formula
  desc "Vulnerability scanner for container images and filesystems"
  homepage "https://github.com/anchore/grype"
  url "https://github.com/anchore/grype/archive/refs/tags/v0.121.3.tar.gz"
  sha256 "ced703b9f94606d33f346369ec3d2f84aaa420147232b633d8d847987f9c64bd"
  license "Apache-2.0"
  head "https://github.com/anchore/grype.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "006c48d816cc37108be8e49ff7da7704ad6f2b6b6fa6b7033daf0ca1927ffebd"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b712bae2553625ade51ac5e06c18e034fb97d4a62e8011fcf525ca1924073f24"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "73023226d6a7acef6b97379f3f52d575a9537b134584444d25cd2573497f2578"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "797951cd09c6559df8ef1a973ff7f256c381a65a212ec17deb35b585ae63bb48"
    sha256 cellar: :any,                 x86_64_linux:      "fa09283f089b91fd5126a25b51d6e65f7eed440289fca0c28c101ba845d9ae31"
  end

  depends_on "go" => :build

  # `test do` block downloads the vulnerability database
  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-X main.version=#{version} -X main.gitCommit=#{tap.user} -X main.buildDate=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/grype"

    generate_completions_from_executable(bin/"grype", "completion")
  end

  test do
    assert_match "database does not exist", shell_output("#{bin}/grype db status 2>&1", 1)
    assert_match "update to the latest db", shell_output("#{bin}/grype db check", 100)
    assert_match version.to_s, shell_output("#{bin}/grype version 2>&1")
  end
end
