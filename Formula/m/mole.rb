class Mole < Formula
  desc "Deep clean and optimize your Mac"
  homepage "https://github.com/tw93/Mole"
  url "https://github.com/tw93/Mole/archive/refs/tags/V1.37.0.tar.gz"
  sha256 "240c8e1791b7f1472621efb090a78ab4bf435ec6046dae9b1fae15991a11588e"
  license "MIT"
  head "https://github.com/tw93/Mole.git", branch: "main"

  # There exists a version like `vx.y.z-windows`
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3053b209de4e8f77edd2203e043a2696de19a3005bc9d674a3c255823e6c42a3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8a4a6fc1c0ec15eff55d5a89828b98384e5db357f7a42189ff83ce59ef0d5981"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f6364b3c741df358fe8af5550271c98f2ebbe3b7c7a24d8d2f6ab21abd16c153"
    sha256 cellar: :any_skip_relocation, sonoma:        "cd92040a2cf31163bf979f2f0a4df37742d25ff13025b06629b508dc6fadfe70"
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
