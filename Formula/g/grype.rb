class Grype < Formula
  desc "Vulnerability scanner for container images and filesystems"
  homepage "https://github.com/anchore/grype"
  url "https://github.com/anchore/grype/archive/refs/tags/v0.122.1.tar.gz"
  sha256 "d801d084d24d19cd916a3cb4aaa1e12b26833f50698cd968c9ff815a0e7839b4"
  license "Apache-2.0"
  head "https://github.com/anchore/grype.git", branch: "main"

  bottle do
    manifest_sha256 "2e1f9254cc491e8370f50893145eb7e38f2e1fbda7468593d14b5636a34f5495"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "9e4230e33fa18052195de3b665529e749f8e9f9ad11eabd8e80a3ef5fac28bf1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "363efbbbf7e39abc78ec7129c801c2d9a21cd4331a721ec4d2e0f4084c857710"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9ef19d34c227706000e85acaefe6326e065b9f99089681492c46b669a6c2565b"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "731006f2e8e4861d8afcf7b0ccbaae2ebdf4224f6054024c1381311daf42b1f7"
    sha256 cellar: :any,                 x86_64_linux:      "d6e2664ed387cca6e0590d44f094d5270275102925d3280b1a3b6ba72328478b"
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
