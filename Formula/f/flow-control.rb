class FlowControl < Formula
  desc "Programmer's text editor"
  homepage "https://flow-control.dev/"
  # version is used to build by `git describe --always --tags`
  url "https://github.com/neurocyte/flow.git",
      tag:      "v0.4.0",
      revision: "7177da5a89e3deb1f40b81be19056aca7c2be6e2"
  license "MIT"
  head "https://github.com/neurocyte/flow.git", branch: "master"

  bottle do
    sha256 arm64_sequoia: "0a5d3cc9d785b501f466207718ffb97cffce91db129afcfb6dfaa503d2fe59ce"
    sha256 arm64_sonoma:  "12a3b4911b97ff46e78c61011ca776c6ee1c77129688406fc4c94a6acd3ad55b"
    sha256 arm64_ventura: "8a12557177dfc3921fb157cd0b17585d71d8ba28ee4beb7e6d0d36e6cfb86a0d"
    sha256 sonoma:        "c7df526005ca5773b016d939085a5226e90155ef85bfb52bf20c5a75d7842c8c"
    sha256 ventura:       "40b97484294f02f7db53af753f7056c7655a4503a1cd7e02a9b8be6fb5adb779"
    sha256 x86_64_linux:  "78ef081b9598566457de7e28b52521e72dae6114f9ecd152933bb463b10ebf6b"
  end

  depends_on "zig" => :build

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
