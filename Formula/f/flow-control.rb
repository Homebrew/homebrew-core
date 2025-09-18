class FlowControl < Formula
  desc "Programmer's text editor"
  homepage "https://flow-control.dev/"
  # version is used to build by `git describe --always --tags`
  url "https://github.com/neurocyte/flow.git",
      tag:      "v0.5.0",
      revision: "28da270834b233e3692153cb0575c051361557ff"
  license "MIT"
  head "https://github.com/neurocyte/flow.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cbbf318d1e534ac9b22beadf0abae72b83abf91a51c92a88b3aca08191cf0e37"
    sha256                               arm64_sequoia: "d0f70361e668717714a34817483d77b464fd659b68b1adf24eeb0c4d789dffec"
    sha256                               arm64_sonoma:  "ecb2d1c4671784f471ba994ee3dcae9f3ef3729f35284f749912de2e84e19c74"
    sha256                               arm64_ventura: "43b0d3d1c6e4fa07bea855432a12d5928b7c78f83a4b1d573fa3504abfd758b0"
    sha256                               sonoma:        "82d5fded191d4b2debc77a45cf34b14f7bf61b742bae3819e29d680f57466449"
    sha256                               ventura:       "49ee95c05c45244f487ff45db7b123bf649036896fd75b933a776c01915c88b6"
    sha256                               x86_64_linux:  "47791b0fb0591a8eeb5c87c6fdf37061ed0457c7a6ae61b289e551f3daece8bb"
  end

  # Aligned to `zig@0.14` formula. Can be removed if upstream updates to newer Zig.
  deprecate! date: "2026-02-19", because: "does not build with Zig >= 0.15"

  depends_on "zig@0.14" => :build

  def install
    # Fix illegal instruction errors when using bottles on older CPUs.
    # https://github.com/Homebrew/homebrew-core/issues/92282
    cpu = case Hardware.oldest_cpu
    when :arm_vortex_tempest then "apple_m1" # See `zig targets`.
    else Hardware.oldest_cpu
    end

    args = []
    args << "-Dcpu=#{cpu}" if build.bottle?

    system "zig", "build", *args, *std_zig_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/flow --version")
    assert_match "Flow Control: a programmer's text editor", shell_output("#{bin}/flow --help")

    # flow-control is a tui application
    system bin/"flow", "--list-languages"
  end
end
