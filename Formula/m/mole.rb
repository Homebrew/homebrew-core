class Mole < Formula
  desc "Deep clean and optimize your Mac"
  homepage "https://github.com/tw93/Mole"
  url "https://github.com/tw93/Mole/archive/refs/tags/V1.30.0.tar.gz"
  sha256 "aec27967827f554e485600c1618f2800c122d096a964f91e80d0a3f2b8cb73c0"
  license "MIT"
  head "https://github.com/tw93/Mole.git", branch: "main"

  # There exists a version like `vx.y.z-windows`
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "af2fed6bcdfe22361d6b3c3e6db2988b8abec38f04ab8a29cc2fa0012388651d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1bd69cf5d516f12a5a340c85ad703b76f81e4f8838104f459122cee51a51a78e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2eaeed06b860f1593a759a436b440b56f8bad6a2a151105e75bb66ddb60928d1"
    sha256 cellar: :any_skip_relocation, sonoma:        "e6ceb3e193407f23f28ef0c0849bab944c82bc47a012af1317f67f884089e8a1"
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
