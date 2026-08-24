class Grype < Formula
  desc "Vulnerability scanner for container images and filesystems"
  homepage "https://github.com/anchore/grype"
  url "https://github.com/anchore/grype/archive/refs/tags/v0.117.0.tar.gz"
  sha256 "314a955453e4f69b3cee1a1982eed8e779ff8ae70e017d37a211d734b9083a94"
  license "Apache-2.0"
  head "https://github.com/anchore/grype.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ff4b40dbe94ea632654424a2d51eaa3f5295bd2fb0494c237a90006cafe623e9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3b9e2bcd5e7358c354b015251b5bcd6ae8ac08688c3e777d07cbbad1c13cc138"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "04ebb6529cf24624518874b26f810c00014285e3b994fb1d1bf2ba3ba512809f"
    sha256 cellar: :any_skip_relocation, sonoma:        "0948259f2c796ec10ab4bed8837298dab7ea872437fc859b37bc98c38e7cd9db"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "11133f4b35591866812f9c72de462a7d1b592895fea908e2631d7dc44fbe354f"
    sha256 cellar: :any,                 x86_64_linux:  "9a7d1515cd53a55dcc9fb9ea18ede93157892e4b7de2574cfe25215cf748f236"
  end

  depends_on "go" => :build

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
