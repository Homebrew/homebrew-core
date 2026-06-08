class Mole < Formula
  desc "Deep clean and optimize your Mac"
  homepage "https://github.com/tw93/Mole"
  url "https://github.com/tw93/Mole/archive/refs/tags/V1.42.0.tar.gz"
  sha256 "3bfe6a59688688502936dcc4afa2f7016f7e11223cf837f4c5e02be8da3dfb57"
  license "MIT"
  head "https://github.com/tw93/Mole.git", branch: "main"

  # There exists a version like `vx.y.z-windows`
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "61af1cdf58986e65d2fa6bc523ea853f7ec00f89ab7d9b8948d4fab71321bfcf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b5763519f0183e869f8980369b5b2e37ce772f14bd7464ac5dbd085395db2b24"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e78b91b16a1aa3a5a982a77f3b86bac9172e9bbf719fdd6bac055a103d9bdade"
    sha256 cellar: :any_skip_relocation, sonoma:        "b09bffd9615b9be8c82bc73450d83517cd64c75cd11a8ef00a515eb3a83ed1d3"
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
