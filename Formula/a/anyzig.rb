class Anyzig < Formula
  desc "Universal zig executable that runs any version of zig"
  homepage "https://github.com/marler8997/anyzig"
  url "https://github.com/marler8997/anyzig/archive/refs/tags/v2026_11_03.tar.gz"
  sha256 "487939d1b2f81b08477ba133a706a0194e67f9a27ef7ed97451b02c9cdf31dc2"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:[._]\d+)+)$/i)
    strategy :git do |tags, regex|
      tags.filter_map { |tag| tag[regex, 1]&.tr("_", ".") }
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f51dbcf41f2217f026643ec67f8d155975eb442611831271074a465bfd98db62"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "3121ab6006dfcc3b27553e23f5287e7e7a2695784ecd454ee2c168f97c86793c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c550139aaaa2b56d94c5e49cb32d8a808ac6e3f1216585491288ceb06b0a6074"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "b6ee428c90bad65e2f29e2052ce4999df8ef0a81428b31c39a3a29b3d94d60e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "719a4540731b243edc39999616b62a417c2e2b18cb075b1ace9bdee0fbbde39f"
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
