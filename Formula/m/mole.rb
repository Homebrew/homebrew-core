class Mole < Formula
  desc "Deep clean and optimize your Mac"
  homepage "https://mole.fit"
  url "https://github.com/tw93/Mole/archive/refs/tags/V1.52.0.tar.gz"
  sha256 "0dfa72eba84c71dca104b927466b1810e5ab9a2515a2156b2c6634cb93f19b90"
  license "GPL-3.0-or-later"
  head "https://github.com/tw93/Mole.git", branch: "main"

  # There exists a version like `vx.y.z-windows`
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1dc3e620b25e551642f5d6be74da44d9927d052f1c988d48dc1e4ed7d98664e8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "df6edd054e69a8d994a6ee9bb9d562dec79fbeb30f4ffb7a65caec08126dc974"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "86f8894b10acc5a9c125fe6a9badcdc2a9d3d240cd606d430feb7a2cbaea124d"
    sha256 cellar: :any_skip_relocation, sonoma:        "2c2c696e297b5af7a438a3eb6f455d26718ca5178a1474aaeb35a74fcfa5ac28"
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
