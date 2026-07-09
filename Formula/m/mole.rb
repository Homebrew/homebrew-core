class Mole < Formula
  desc "Deep clean and optimize your Mac"
  homepage "https://mole.fit"
  url "https://github.com/tw93/Mole/archive/refs/tags/V1.44.1.tar.gz"
  sha256 "fa5abe50f190de58bba273352928fbae80a7214d0711937d27914edf7af2da1e"
  license "GPL-3.0-or-later"
  head "https://github.com/tw93/Mole.git", branch: "main"

  # There exists a version like `vx.y.z-windows`
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2d7de7e43617358d520188981af3dadd17a0bc8379143647b58ebb4dc8009e54"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9eae9fcaca512ce232eb0b43eaa8aa003d64e54ef7eaa5a58b54233442b1ff6d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "619a840adb0551ff8876f1eb2cf31893506fd5059f70905191a397f321688d4a"
    sha256 cellar: :any_skip_relocation, sonoma:        "2f3dcf2278e7af81ebc09c96c453c426860e947214bb3f4f27e742768ceffcd0"
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
