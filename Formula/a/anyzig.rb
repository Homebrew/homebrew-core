class Anyzig < Formula
  desc "Universal zig executable that runs any version of zig"
  homepage "https://github.com/marler8997/anyzig"
  url "https://github.com/marler8997/anyzig/archive/refs/tags/v2026_11_12.tar.gz"
  sha256 "5403be7549905990e98f036f920536cbf5948008a818cfb1587e408029333133"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:[._]\d+)+)$/i)
    strategy :git do |tags, regex|
      tags.filter_map { |tag| tag[regex, 1]&.tr("_", ".") }
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "6004e78570797f615903092c18a3f5e8ba15ef1894514f0ebc2b528418179880"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "8c85a54f13e90b84484c214ad3413723c828c414aabbf41f08a7103c6db9cbe6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "63a2f299e178d499dbce83ae53551ec92de8926585fd0f29ce8987d97813c306"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "fb9566d6579255093365e7e67c4c70081299ba9c92e2daca1a8ee22a439640af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "a65799eb719b1d60b83dfe63ade4ed967dce2979687f86c9c7bf1143ca407f98"
  end

  keg_only "it conflicts with zig"

  depends_on "zig" => :build

  deny_network_access!

  def fetch
    system "zig", "build", "--fetch=all"
  end

  def install
    # zig-patch preserves the read-only permissions of Homebrew's Zig standard library.
    cp_r formula_opt_lib("zig")/"zig", buildpath/"zig-lib"
    chmod_R "u+w", buildpath/"zig-lib"
    ENV["ZIG_LIB_DIR"] = buildpath/"zig-lib"

    args = %W[-Dforce-version=v#{version.to_s.tr(".", "_")}]
    system "zig", "build", *args, *std_zig_args
  end

  test do
    assert_match "v#{version.to_s.tr(".", "_")}", shell_output("#{bin}/zig any version").strip
    system bin/"zig", "any", "list-installed"
  end
end
