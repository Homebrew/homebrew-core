class Mole < Formula
  desc "Deep clean and optimize your Mac"
  homepage "https://mole.fit"
  url "https://github.com/tw93/Mole/archive/refs/tags/V1.47.0.tar.gz"
  sha256 "2a4a60f29608849364a2ac999e4e59468bec2ab0d170f69cd9245d2809c413e8"
  license "GPL-3.0-or-later"
  head "https://github.com/tw93/Mole.git", branch: "main"

  # There exists a version like `vx.y.z-windows`
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2896ca4469f745abba550f9a99588523596169be7c3116b27643f888b83fe253"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2b873b6114fe5f011b40f3cc5f24cde45382a53b30f5908f16c8b14c40071abb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aa30fe517d04cf8a1c4f4ebe364bc77022867805047a46f7f4dfde6bdfd93454"
    sha256 cellar: :any_skip_relocation, sonoma:        "61b2280c3d2ee942c627aa0681f9cd66fd8ace1bf22a011eaa2503a0b03aee26"
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
