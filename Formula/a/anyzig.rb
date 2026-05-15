class Anyzig < Formula
  desc "Universal zig executable that runs any version of zig"
  homepage "https://github.com/marler8997/anyzig"
  url "https://github.com/marler8997/anyzig/archive/refs/tags/v2026_03_26.tar.gz"
  sha256 "bad066c1d98a4ac469cf1d9a0203a3be65425d4cd0bc1f1a3dbf042ebb9c1c62"
  license "MIT"

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b74b8a10618d168a874dfb7cbb1bd8a32a81347b6a818f223b47867090b86f23"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e325f79fe7feec7d8be39362aeb50782bf324ea99c074fb1eb392dc7991e0b96"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "22edb36bfb2d62b7c3e70b970fb811fc9c3609eefe87181d5e7c5200b2e8a206"
    sha256 cellar: :any_skip_relocation, sonoma:        "1b8227dc878ab1f9ddb379e15ae0d886f40dcdd4a472314c6fb96eafe96a075c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eff964177238e0129e2dce0d96b6e0c09a690da2135148607b6597f409179034"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0ec5b50befefe7b3e36c11b2ad750ba9e64905a1594fc3ec5d74a08b5e8abd82"
  end

  # Aligned to `zig@0.14` formula. Can be removed if upstream updates to newer Zig.
  deprecate! date: "2026-08-19", because: "does not build with Zig >= 0.15"
  disable! date: "2027-08-19", because: "does not build with Zig >= 0.15"

  depends_on "zig@0.14" => :build # https://github.com/marler8997/anyzig/pull/76

  conflicts_with "zig", because: "both install `zig` binaries"

  def install
    args = %W[-Dforce-version=v#{version.to_s.tr(".", "_")}]

    # Fix illegal instruction errors when using bottles on older CPUs.
    # https://github.com/Homebrew/homebrew-core/issues/92282
    cpu = case ENV.effective_arch
    when :arm_vortex_tempest then "apple_m1" # See `zig targets`.
    when :armv8 then "xgene1" # Closest to `-march=armv8-a`
    else ENV.effective_arch
    end
    args << "-Dcpu=#{cpu}" if build.bottle?

    system "zig", "build", *args, *std_zig_args
  end

  test do
    assert_match "v#{version.to_s.tr(".", "_")}", shell_output("#{bin}/zig any version").strip
    system bin/"zig", "any", "list-installed"
  end
end
