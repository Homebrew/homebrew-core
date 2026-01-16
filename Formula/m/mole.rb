class Mole < Formula
  desc "Deep clean and optimize your Mac"
  homepage "https://github.com/tw93/Mole"
  url "https://github.com/tw93/Mole/archive/refs/tags/V1.21.0.tar.gz"
  sha256 "1768b2ba21938a7b9b5a9990b589767364a0e048d2603031e8ee357180c21981"
  license "MIT"
  head "https://github.com/tw93/Mole.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7e8880161dbffa2656390091a5ed7f90c27762277535ee5c8c73cff6e281adeb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a4b302340a6408d2245e9b6d8545a1c618518132803370ec8caa44e357d0142c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2c45522a8b01ba795aea70a3991283f0e83eba31adb3f66e848012522fc00e95"
    sha256 cellar: :any_skip_relocation, sonoma:        "fcc6e74f5bda5942305b9d8684e74051c115ce55d53539be24fc21d33b3a1e87"
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
