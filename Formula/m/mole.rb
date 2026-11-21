class Mole < Formula
  desc "Deep clean and optimize your Mac"
  homepage "https://mole.fit"
  url "https://github.com/tw93/Mole/archive/refs/tags/V1.74.0.tar.gz"
  sha256 "38373477ded5047a05a0a6dd98cbf3c7d45de8f5c768d34e16d5ab961d19cbbe"
  license "GPL-3.0-or-later"
  head "https://github.com/tw93/Mole.git", branch: "main"

  # There exists a version like `vx.y.z-windows`
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7ee429174f601d5e4d65d5cfc7cb10434a06a21e94a2f80ecc73acebb8529ffc"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "54aa5238f7e821130beb95e48e5ae4db237f5bfc1d870e8c98c725df16a02e02"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "8a0d756dcb84d0673faeb48c8aedad1425d14c4382e433336782181ccf32de11"
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
