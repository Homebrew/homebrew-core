class Nullclaw < Formula
  desc "Tiny autonomous AI assistant infrastructure written in Zig"
  homepage "https://nullclaw.io"
  url "https://github.com/nullclaw/nullclaw/archive/refs/tags/v2026.3.21.tar.gz"
  sha256 "20fb3cfedd316cf3f5f6c3b9870397c3e89088c0e374f57b5c58157bdd96c796"
  license "MIT"
  head "https://github.com/nullclaw/nullclaw.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f25b6d645a10aa39e44294ad211afb36294292101d443fa52abccf50bafe8b39"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "73d96a3fa05a23eb42e94915133f346c7cf8f7f2c0157ac6d5cf180370461560"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "34b9a0ba407a355f405a22a330686a6502a56dbbe21a5c7bfcfd1808a4f59cf3"
    sha256 cellar: :any_skip_relocation, sonoma:        "2dfc6cc527b27a53b9c605c4dd36c2da6f29c58a9f1df7822e5e1814b4f6fbea"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6b11dabb867f0b9327389d51a6be1c7fccc766ec341e207baba177a750a5ae17"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "daa0dea6d3735d1a6bc008baecfcce2f14040b591e82a514c8c7554a34de14eb"
  end

  depends_on "zig" => :build

  def install
    # Fix illegal instruction errors when using bottles on older CPUs.
    # https://github.com/Homebrew/homebrew-core/issues/92282
    cpu = case ENV.effective_arch
    when :arm_vortex_tempest then "apple_m1" # See `zig targets`.
    when :armv8 then "xgene1" # Closest to `-march=armv8-a`
    else ENV.effective_arch
    end

    args = ["-Dversion=#{version}"]
    args << "-Dcpu=#{cpu}" if build.bottle?

    system "zig", "build", *args, *std_zig_args
  end

  service do
    run [opt_bin/"nullclaw", "daemon"]
    keep_alive true
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nullclaw --version")

    output = shell_output("#{bin}/nullclaw status 2>&1")
    assert_match "nullclaw Status", output
  end
end
