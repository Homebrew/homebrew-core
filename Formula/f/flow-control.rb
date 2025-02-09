class FlowControl < Formula
  desc "Flow Control: a programmer's text editor"
  homepage "https://github.com/neurocyte/flow"
  url "https://github.com/neurocyte/flow/archive/refs/tags/v0.3.2.tar.gz"
  sha256 "f495084d926cfbb35323c21f11cdb9382e40790534600677526b4367cdd26602"
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
    assert_predicate bin/"flow", :exist?, "Binary not found"
    assert_predicate bin/"flow", :executable?, "Binary is not executable"
  end
end
