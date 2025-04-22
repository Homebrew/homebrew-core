class FlowControl < Formula
  desc "Programmer's text editor"
  homepage "https://flow-control.dev/"
  # version is used to build by `git describe --always --tags`
  url "https://github.com/neurocyte/flow.git",
      tag:      "v0.3.3",
      revision: "fb5cd46d0b1fd277d6de3ded0a9d1d99bd73d643"
  license "MIT"
  head "https://github.com/neurocyte/flow.git", branch: "master"

  bottle do
    sha256 arm64_sequoia: "6ed1b2aaf297e50e5782d85c71a6fd23bd8705043e79281e194d68520661e11f"
    sha256 arm64_sonoma:  "2ddcea938d0eb9f7aa4560991d7a4d2f3fe89e322d4cac67ed5b70f7e04e73f8"
    sha256 arm64_ventura: "8920bb92cd7af18d0083540e6f82fe331e66ca3fa22f1c7da0bddd7dfe1333dd"
    sha256 sonoma:        "3dbbd4c191c10a804a204e128c8a2d5b68a929eada6350ca925cf4ded0fc8e1e"
    sha256 ventura:       "8d451e9e64769726bf5a84998c97d9af902b0f01db2f41223ef22a36f8cfcf0b"
    sha256 x86_64_linux:  "020d09612e1d13fe77f68f55bf14f6b47e3a26cbbdbe7af42228f3e4e602af78"
  end

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
