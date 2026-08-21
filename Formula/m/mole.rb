class Mole < Formula
  desc "Deep clean and optimize your Mac"
  homepage "https://mole.fit"
  url "https://github.com/tw93/Mole/archive/refs/tags/V1.51.0.tar.gz"
  sha256 "9d5e4340c6e5fcfa7f73df30d2a46363600297f8d6ae159b08d4fcf740331852"
  license "GPL-3.0-or-later"
  head "https://github.com/tw93/Mole.git", branch: "main"

  # There exists a version like `vx.y.z-windows`
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b54539e05a3a1e9b74cea41ddedcee570b9a56fff2764fc853d98325aa102d0e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "572d3331f30733d32f842885717e204dbcfbe71c4b57df9b51682ed4244dbf11"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2a07632c7963eb4a158d789932c3580625e43b7cc39889a62b47d43d16232be4"
    sha256 cellar: :any_skip_relocation, sonoma:        "7d9127c9da62447fdaffc5935b751972b4a7df389a0e0ab81f6104f51491a24b"
  end

  depends_on "go" => :build
  depends_on :macos

  def install
    # Remove prebuilt binaries
    buildpath.glob("bin/*-go").map(&:unlink)
    ldflags = "-X main.Version=#{version} -X main.BuildTime=#{time.iso8601}"
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
