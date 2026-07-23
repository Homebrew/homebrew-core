class Mole < Formula
  desc "Deep clean and optimize your Mac"
  homepage "https://mole.fit"
  url "https://github.com/tw93/Mole/archive/refs/tags/V1.47.1.tar.gz"
  sha256 "5f5c8a01c67b644e7bba65a9b39d61461ab0543a2dfa9e755b54cfacdf21fa10"
  license "GPL-3.0-or-later"
  head "https://github.com/tw93/Mole.git", branch: "main"

  # There exists a version like `vx.y.z-windows`
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "20f9ba042399573556edc93aca8119e16a7c79c9a94b2cff2a1a74fb237423cd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9ee73a4b3c40178784daec4d988890a0391af9ecf24468c4752d7d13aa2fe1af"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "33fd7cbf0e8f05f08917bb238146d6a442120bc4b86316b940bc706a82604fbd"
    sha256 cellar: :any_skip_relocation, sonoma:        "d8c4222ec38aabeea22b3beabcad0bccdb493badf1c7f644b26d5e2a15e95722"
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
