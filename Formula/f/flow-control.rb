class FlowControl < Formula
  desc "Programmer's text editor"
  homepage "https://flow-control.dev/"
  # version is used to build by `git describe --always --tags`
  url "https://github.com/neurocyte/flow.git",
      tag:      "v0.6.0",
      revision: "98855a73e4b5f01b282d3a735ca205934a226627"
  license "MIT"
  head "https://github.com/neurocyte/flow.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f5e85dd432761339ceb1c88cf8a77b6efdb779cd2639e8fd09467dd12b5a17a3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0c9cedc55d75b3065e8af56ee5899c47ce9015b29da37bb2f003f24ab23f6926"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ecc03f7623d90add75cec14f758fc7ab4888e6506287c43c45055c60740eaa68"
    sha256 cellar: :any_skip_relocation, sonoma:        "60b5deb512575bc57991fd4cd70daa826e24bb700468794971bb84bcbf137ff8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "54787298d0520e4c3e1fcd99eb9feaf4d9bbaaf20400ede6de120c6c687bf4fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aa06ccddd48bdcc21b70455bc3b3e41ed4543ad1645dedddedd8f3cea38f0483"
  end

  depends_on "zig" => :build

  def install
    # Fix illegal instruction errors when using bottles on older CPUs.
    # https://github.com/Homebrew/homebrew-core/issues/92282
    cpu = case Hardware.oldest_cpu
    when :arm_vortex_tempest then "apple_m1" # See `zig targets`.
    when :armv8 then "xgene1" # Closest to `-march=armv8-a`
    else Hardware.oldest_cpu
    end

    # Do not use `std_zig_args` or `--release=` flag here
    # as after using it all targets are installed into directories with
    # names like `<os>-<arch>-release` instead of `bin`
    args = %W[
      --prefix #{prefix}
      -Doptimize=ReleaseFast
      --summary all
    ]
    args << "-Dcpu=#{cpu}" if build.bottle?
    args << "-fno-rosetta" if OS.mac? && Hardware::CPU.intel?

    system "zig", "build", *args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/flow --version")
    assert_match "Flow Control: a programmer's text editor", shell_output("#{bin}/flow --help")

    # flow-control is a tui application
    system bin/"flow", "--list-languages"
  end
end
