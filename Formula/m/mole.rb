class Mole < Formula
  desc "Deep clean and optimize your Mac"
  homepage "https://mole.fit"
  url "https://github.com/tw93/Mole/archive/refs/tags/V1.75.0.tar.gz"
  sha256 "120a3ebaf9102a64c1ae12ee1fd3bac34db2b6380ac58993dafb2c18c5862594"
  license "GPL-3.0-or-later"
  head "https://github.com/tw93/Mole.git", branch: "main"

  # There exists a version like `vx.y.z-windows`
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    manifest_sha256 "6564a122bb6021daf867dc4cb811d1c8bd2d7eb56882ddc9e02be566c002def7"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "699f3f7154f7d9ffca91ab0bcfde4ad066bee1acaca7579a1a405988d42bf5b9"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "94cbaf6258ab04bf3c7f4347abdda22510940897337545d6d7ff1c4da9ab671a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1c97684b73cb05202f9289b24a5188f36a8aa8216685fe7619a66c5a078708a3"
  end

  depends_on "go" => [:build, :no_linkage]
  depends_on :macos

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    # Remove prebuilt binaries
    buildpath.glob("bin/*-go").map(&:unlink)

    ldflags = "-X main.Version=#{version} -X main.BuildTime=#{time.iso8601}"
    %w[analyze status].each do |cmd|
      system "go", "build", *std_go_args(ldflags:, output: buildpath/"bin/#{cmd}-go"), "./cmd/#{cmd}"
    end

    libexec.install "mole", "bin", "lib"
    bin.install_symlink libexec/"mole"
    bin.install_symlink bin/"mole" => "mo"

    generate_completions_from_executable(bin/"mole", "completion")
  end

  test do
    # Point simctl at the CLT so the sandboxed Xcode simulator probes are skipped
    ENV["DEVELOPER_DIR"] = "/Library/Developer/CommandLineTools"
    assert_match version.to_s, shell_output("#{bin}/mole --version")
    output = shell_output("#{bin}/mole clean --dry-run 2>&1")
    assert_match "Dry run complete - no changes made", output
  end
end
