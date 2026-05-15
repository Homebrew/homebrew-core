class Mole < Formula
  desc "Deep clean and optimize your Mac"
  homepage "https://github.com/tw93/Mole"
  url "https://github.com/tw93/Mole/archive/refs/tags/V1.38.1.tar.gz"
  sha256 "92a6f496f080563df7811ca711cdd3fc3aad1df1b6d90ed43f5c7e78fbee745c"
  license "MIT"
  head "https://github.com/tw93/Mole.git", branch: "main"

  # There exists a version like `vx.y.z-windows`
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "87b4bc57f7f2687fcb732ff25f8eef6d4635e92d0242370b1eb84424cae2de34"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6cd4873b6c11673fef475c591bc25822d5b9167a62e8f86dcfe9a2a6aecc3bb3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ef07d5675c1c372f8b52427e41da5c38003c7bf5fbf1ede312d0ad86e06b20bf"
    sha256 cellar: :any_skip_relocation, sonoma:        "492cd37db1c1ed05f96a53bf56a5076369ff016d2d8498fb370514aad4e3596d"
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
