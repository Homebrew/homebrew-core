class Mole < Formula
  desc "Deep clean and optimize your Mac"
  homepage "https://github.com/tw93/Mole"
  url "https://github.com/tw93/Mole/archive/refs/tags/V1.36.1.tar.gz"
  sha256 "0716376f2391dead6402ef2d39b5d46c2d86d835ca2b131419358ece77ecf27d"
  license "MIT"
  head "https://github.com/tw93/Mole.git", branch: "main"

  # There exists a version like `vx.y.z-windows`
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cca480096ac1a9da0d2c5a73337e93225985c8ada8aa1f9b6ca2877b9fc534d8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ff19e89654ad84a600234a0288580cc20ac1c59191435f1e7326b380aeac3428"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b990af2f94184ac76a167f40fd1bd5d6b6749f66329b5e65f14b28e033668f37"
    sha256 cellar: :any_skip_relocation, sonoma:        "e982598847c4ff30b0bc2c75c8c1e2568657e3cf268deeb6b9e05c576e110346"
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
