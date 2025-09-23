class Anyzig < Formula
  desc "Universal zig executable that runs any version of zig"
  homepage "https://github.com/marler8997/anyzig"
  url "https://github.com/marler8997/anyzig/archive/refs/tags/v2025_08_13.tar.gz"
  sha256 "13511963d0dc570f5fe47ec83a23ff2982b53f1516076014aab6ec54638c0f3e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3a99919f4b637901bae427daed3dddf878f9451e91478865002cdc69ce6cd76c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "75f2f35ec40057c925cc718abdf3459c81579e48024ed7b6ca241411997dea35"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "24180b09b6c8af369b6477ad37ceabd6e852cce19f6e19a8442eec86fcf94224"
    sha256 cellar: :any_skip_relocation, sonoma:        "3efd0d1c34480b8fd4174b30156740addf1afa7eedaf207b71f0602205d95569"
    sha256 cellar: :any_skip_relocation, ventura:       "a5c9630295c2bbc7ebe1115812140c7cdff797e3caff6ee9d82a8935dc978f62"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "830e8aaa8c8aabaa5252e53504f2dd18e113dc86aa12b18f8c574c264bb5cdd0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1d68a435c3c52c8d944409175fe05f977932382420388bda1f341edb3270d6cc"
  end

  keg_only "it conflicts with zig"

  depends_on "zig" => :build

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
