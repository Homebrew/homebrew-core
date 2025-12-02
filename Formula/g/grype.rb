class Grype < Formula
  desc "Vulnerability scanner for container images and filesystems"
  homepage "https://github.com/anchore/grype"
  url "https://github.com/anchore/grype/archive/refs/tags/v0.104.1.tar.gz"
  sha256 "aa32307f55007cbed13042db865b69f7beb560699e22458b08080b5561e2169a"
  license "Apache-2.0"
  head "https://github.com/anchore/grype.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "773008712d1f1b531055cffb881710db561428cbe6ccb500609cc95770f37e9a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c65a60d05b5c737343f1022e9800d74963b9a77af29f81a97f7c751862c0cf62"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cff782ce79c5a24954fbdcc19704cc1e2a3a2d195ed9533f9ad6411d0d6298f5"
    sha256 cellar: :any_skip_relocation, sonoma:        "72799c639f0210dd3b3adbc72ca5379e56aec5f2245432d56beb8097fba7e304"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "45de82a65fabcbd336bc6bb9b3ac4b9a41ab018d1a62a8747e0ac56990c263a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6db4fca9ffa7134b34ead6e4df50431112a448d8cc2d20250fef351aeb596dfe"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.gitCommit=#{tap.user} -X main.buildDate=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/grype"

    generate_completions_from_executable(bin/"grype", "completion")
  end

  test do
    assert_match "database does not exist", shell_output("#{bin}/grype db status 2>&1", 1)
    assert_match "update to the latest db", shell_output("#{bin}/grype db check", 100)
    assert_match version.to_s, shell_output("#{bin}/grype version 2>&1")
  end
end
