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
    manifest_sha256 "3830c5e2ad077c17fb988b2b5fd6d7a306cce0b7466757b84fe1d0f09024a599"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "2cdbf94ed91bc8c29b385633c1b3c36ffbeeff24615e08db94d8213359995847"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "0be5d5e7f368741da008f24571be973f743d7ccef011d1d3b39f13f9a02064df"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d7719cbc4aaf795349d5d523b3251cb916cbf737b905379b0e085d80a1a6ceec"
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
