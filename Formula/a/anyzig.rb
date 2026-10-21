class Anyzig < Formula
  desc "Universal zig executable that runs any version of zig"
  homepage "https://github.com/marler8997/anyzig"
  url "https://github.com/marler8997/anyzig/archive/refs/tags/v2026_10_13.tar.gz"
  sha256 "fa87b33ea91cda5f7df7bfb74fdb4ead644b53f68a5bdf9480b7292bcb1affbe"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:[._]\d+)+)$/i)
    strategy :git do |tags, regex|
      tags.filter_map { |tag| tag[regex, 1]&.tr("_", ".") }
    end
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "59f476bf71a90d6166bb03115d81576680f174d2158ee6d04fd073afe8191448"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b48dc89c7179364378d93e421209812f5514f4adcca340a3a88d4196dde79aa5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b7fc211cf8b92a6ba711060929c8f4091e9486be706dafb78037ccb02b48a6f0"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "c36b277f82fbd5b97605f15f09399006c656db2df8d48790cd7dbe13e7363466"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "e0f6b8a9e59298eb131045a38d6444a3d26c735fcfc77916ae758936d8f0a5c8"
  end

  keg_only "it conflicts with zig"

  depends_on "zig" => :build

  deny_network_access!

  def fetch
    system "zig", "build", "--fetch"
  end

  def install
    args = %W[-Dforce-version=v#{version.to_s.tr(".", "_")}]
    system "zig", "build", *args, *std_zig_args
  end

  test do
    assert_match "v#{version.to_s.tr(".", "_")}", shell_output("#{bin}/zig any version").strip
    system bin/"zig", "any", "list-installed"
  end
end
