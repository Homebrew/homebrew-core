class Mole < Formula
  desc "Deep clean and optimize your Mac"
  homepage "https://github.com/tw93/Mole"
  url "https://github.com/tw93/Mole/archive/refs/tags/V1.31.0.tar.gz"
  sha256 "fc7a6b92b602588b5aa256bb6dd382d409bd8fbf57cc09fe041d7c86a7400edd"
  license "MIT"
  head "https://github.com/tw93/Mole.git", branch: "main"

  # There exists a version like `vx.y.z-windows`
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6389f2651f866f43f38a124f82a3c7f3b1a40e15f5b14d2ff7b8a11bdda08def"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6140fc3a7c89c315bcb60890b9a9ee3a07e9d17688d8d3cad89c482e5b9b90b2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b731af5914598964958a736543f27fd17b1bf7d4c0a3a286d5bdab6042fb8ccd"
    sha256 cellar: :any_skip_relocation, sonoma:        "e6f368570034da6312ed796a28f7cc12443d0db3068c795f2b357aa6d6d75335"
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
