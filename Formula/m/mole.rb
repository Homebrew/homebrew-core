class Mole < Formula
  desc "Deep clean and optimize your Mac"
  homepage "https://github.com/tw93/Mole"
  url "https://github.com/tw93/Mole/archive/refs/tags/V1.34.0.tar.gz"
  sha256 "88fef28969694e134fd7f6167246836c69cb97dcf1959ed90a8330aaf0b61f0d"
  license "MIT"
  head "https://github.com/tw93/Mole.git", branch: "main"

  # There exists a version like `vx.y.z-windows`
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bfda45405df8bd6e54a0da7ee03da4bc5b880205621ed5e0a8bd0c70488c233f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "448495337a445da8c3761a0dd263b02b57626cb3e169dd1bb7b848e74aadd17d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2ef8e4553c88931acb84ba0014877f7debfce3f0ad0b9d7e54bfa6d7ad1ff80a"
    sha256 cellar: :any_skip_relocation, sonoma:        "b8dcac07b92a9fad533620b19eb8e807daa0e302f6865b0a40d6cce82c8e3fa7"
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
