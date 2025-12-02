class Anyzig < Formula
  desc "Universal zig executable that runs any version of zig"
  homepage "https://github.com/marler8997/anyzig"
  url "https://github.com/marler8997/anyzig/archive/refs/tags/v2025_10_15.tar.gz"
  sha256 "65ebdeca9e20ac347d094b504c3198eab25f130638e91554f517eef1c0275c2c"
  license "MIT"

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b742bd26786d46db9dfe46088fc423d3ea4020eb1bdab90fe871b1c157682822"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b8b788c7f65dff73b02212d1b5bbd35f0d55106d4064853848371111a0cb0220"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "05c25f2403072fba5eb711fd62b2f6e97d4d2753344e2ef0d0e330d920aa883a"
    sha256 cellar: :any_skip_relocation, sonoma:        "0205666a6552cd3e57c8c65e4f842939d6cfae318506bc7fa482e9069e185802"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "259c4a5bcec54b7948dcc82ce6cc003575e63b5fa35049ac389ebe258c8b756e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b96df77ca3f2ffd21ff157661045237683a954504516c300c8965232329446c3"
  end

  depends_on "zig@0.14" => :build

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
