class Mole < Formula
  desc "Deep clean and optimize your Mac"
  homepage "https://github.com/tw93/Mole"
  url "https://github.com/tw93/Mole/archive/refs/tags/V1.23.1.tar.gz"
  sha256 "403c36f51f2411618de03fe153894129dde9b98fb58a9d465e19bda20047a34b"
  license "MIT"
  head "https://github.com/tw93/Mole.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f92884f4e553cf5a26fb90205f089db4b6526861b9a965ae67281790cd34d7e0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "571a4e7d0adcba123a18487130f17d69968d52db01d636ab0833b6a8cfa2331d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e34f6b6c9219b76d7bdb39bf632f6f4d9bd9076bd64699c993492dfddfd28d53"
    sha256 cellar: :any_skip_relocation, sonoma:        "8e3fe03cf624c16bf3d03aa9d937309ec95df37931bab2917b0eeaa2b01f2804"
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
