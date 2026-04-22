class Mole < Formula
  desc "Deep clean and optimize your Mac"
  homepage "https://github.com/tw93/Mole"
  url "https://github.com/tw93/Mole/archive/refs/tags/V1.35.0.tar.gz"
  sha256 "c9d9b30b2783946cb38ea98bc157f7becfb320f140fdedf0ec01d05cfcab2053"
  license "MIT"
  head "https://github.com/tw93/Mole.git", branch: "main"

  # There exists a version like `vx.y.z-windows`
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2c464a4314dbb8307560b2fa0df79326e67118248bfb133f398fdd61b6eb0f00"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b556bdef2cfbd2fa546b334f4f90d4b3107e76acbb0b43e82cd6e399fc4db4a3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b0997904461a4812ed00aa3f16e0497fdd73921a3f7752b3751f060a17f42275"
    sha256 cellar: :any_skip_relocation, sonoma:        "580854e16ab9f980539eeec8a78b846f7ad477e1185acb3d6e5e69fc254a6869"
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
