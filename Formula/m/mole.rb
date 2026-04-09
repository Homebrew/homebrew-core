class Mole < Formula
  desc "Deep clean and optimize your Mac"
  homepage "https://github.com/tw93/Mole"
  url "https://github.com/tw93/Mole/archive/refs/tags/V1.33.0.tar.gz"
  sha256 "c6641d8c54bf253c740df5bc22b20bbeb321e91a92a57120cf42d2edd4050001"
  license "MIT"
  head "https://github.com/tw93/Mole.git", branch: "main"

  # There exists a version like `vx.y.z-windows`
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "775fda22b04ef73d81948a045746a26060a60b20979e30775622e7f0a8f50ac6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1615ff2699eee50873299765c5e8c3bd49205059194499900bb6fe112d630444"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ad6a771dcf5e63a020610d6415e6ecc5e1a338119edf09cdcf78b37c9a662dc4"
    sha256 cellar: :any_skip_relocation, sonoma:        "8fd9a759ac9776e86fbd4cb27e07b073ac66aeed0b9c06b452357fbbdce61b4e"
  end

  depends_on "go" => :build
  depends_on :macos

  def install
    # Remove prebuilt binaries
    buildpath.glob("bin/*-go").map(&:unlink)
    ldflags = "-s -w -X main.Version=#{version} -X main.BuildTime=#{time.iso8601}"
    %w[analyze status].each do |cmd|
      system "go", "build", *std_go_args(ldflags:, output: buildpath/"bin/#{cmd}-go"), "./cmd/#{cmd}"
    end

    inreplace "mole", 'SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"',
                      "SCRIPT_DIR='#{libexec}'"
    libexec.install "bin", "lib"
    bin.install "mole"
    bin.install_symlink bin/"mole" => "mo"
    generate_completions_from_executable(bin/"mole", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mole --version")
    output = shell_output("#{bin}/mole clean --dry-run 2>&1")
    assert_match "Dry run complete - no changes made", output
  end
end
