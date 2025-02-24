class FlowControl < Formula
  desc "Programmer's text editor"
  homepage "https://flow-control.dev/"
  # version is used to build by `git describe --always --tags`
  url "https://github.com/neurocyte/flow.git",
      tag:      "v0.3.3",
      revision: "fb5cd46d0b1fd277d6de3ded0a9d1d99bd73d643"
  license "MIT"
  head "https://github.com/neurocyte/flow.git", branch: "master"

  depends_on "zig"

  def install
    # Fix illegal instruction errors when using bottles on older CPUs.
    # https://github.com/Homebrew/homebrew-core/issues/92282
    cpu = case Hardware.oldest_cpu
    when :arm_vortex_tempest then "apple_m1" # See `zig targets`.
    else Hardware.oldest_cpu
    end

    args = %W[
      --prefix #{prefix}
      -Doptimize=ReleaseFast
    ]
    args << "-Dcpu=#{cpu}" if build.bottle?

    system "zig", "build", *args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/flow --version")
    assert_match "Flow Control: a programmer's text editor", shell_output("#{bin}/flow --help")

    # flow-control is a tui application
    system bin/"flow", "--list-languages"
  end
end
