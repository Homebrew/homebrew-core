class Mole < Formula
  desc "Deep clean and optimize your Mac"
  homepage "https://github.com/tw93/Mole"
  url "https://github.com/tw93/Mole/archive/refs/tags/V1.26.0.tar.gz"
  sha256 "00109b9a10961b083daf10709cf0c450670e5d4e3ea02ecc422b5c06534f3259"
  license "MIT"
  head "https://github.com/tw93/Mole.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "088c466a790e7131ccdb0097997803b52e6b15a04c05e68ef7d4f1fbba6dad01"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3f927c14f3a935be0ebb384ec506cd53f69ef961b0eb8075b35f57102108d2e1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e93d5b2fed3cfdd13ce5547aa72d3186c78e87039b138161c9116123d266e239"
    sha256 cellar: :any_skip_relocation, sonoma:        "35893ea4151c8c3e4648531b71074a0489fbe8b6f9c6a669e01d36520eacbbfa"
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
