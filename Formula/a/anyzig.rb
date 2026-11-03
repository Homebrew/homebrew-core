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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d4a7b9611e0e5a3ad8358e21d71eaad27f0b34c8bd15380927e187b77d15ceaf"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "3662964bd5b89a8d2879002d4ffac4155fb6fcf3e9caa3515429614fc05f8dcf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "8ed236213836d3f1185077dde2817ffd21d1339c1396fb114e06bb1e10d85013"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "53f797212f335711a0cecf9acb462f17c7b1ca58dfea72ffc3e2ff6a28cbca03"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "50ae08f6ce3bd06cf87bb16b3fd67d616d4ce85ebc755029b1e8d88229d8df41"
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
