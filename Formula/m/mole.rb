class Mole < Formula
  desc "Deep clean and optimize your Mac"
  homepage "https://github.com/tw93/Mole"
  url "https://github.com/tw93/Mole/archive/refs/tags/V1.15.1.tar.gz"
  sha256 "ee6dedb2bb953686db5d6d6b21bd277226fa06b60fb3f55ee9b0f5089334491c"
  license "MIT"
  head "https://github.com/tw93/Mole.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "07fc8bb8738f9d71b4755069af2781a6d04aaf062993895be56871ac769547eb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f0aba59973054eb2706413e89817ae754b8de591fbcc144481b28ff85c82826c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "efb37fd2dcbb879e4e51998c982a57b8d4ef6c1725972eb57240fc772d09606a"
    sha256 cellar: :any_skip_relocation, sonoma:        "06a6a41c5257806efa23dd0e3f74c5a81955661333d0e5d421ea726d23b1ffd9"
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
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mole --version")
    output = shell_output("#{bin}/mole clean --dry-run 2>&1")
    assert_match "Dry run complete - no changes made", output
  end
end
