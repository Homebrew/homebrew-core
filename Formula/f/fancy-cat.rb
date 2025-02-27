class FancyCat < Formula
  desc "PDF reader for terminal emulators using the Kitty image protocol"
  homepage "https://github.com/freref/fancy-cat"
  url "https://github.com/freref/fancy-cat/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "d062d1569dcf2ad664b61426f3a506bed653df3da1d0480a302a7e560c035622"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "d12990678c4072a43aa05986d1513e50c7ea99b949c40739a967ccf71eff1977"
    sha256 cellar: :any,                 arm64_sonoma:  "bd6b511521b63625553e008e395532c724d3e7e3c58e7e45250b6f3c77a00927"
    sha256 cellar: :any,                 arm64_ventura: "76940b4ef61d513168042b3a7c685d0c849de25f23d4fdb0346693b91a16641f"
    sha256 cellar: :any,                 sonoma:        "df6618f24ba5d6ddd25c72fc45febe04794489ecff753b813cd893b4fd979a9a"
    sha256 cellar: :any,                 ventura:       "99cb60960cab7749739a1c9707dc2bdf60f1212d55dc642a5edab24ff8f11580"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "210539b80b7fdfedd1e27cfbf36ad1f516eed15620c7a70f7cead4ce29699e3e"
  end

  depends_on "zig" => :build
  depends_on "mupdf"

  def install
    # Fix illegal instruction errors when using bottles on older CPUs.
    # https://github.com/Homebrew/homebrew-core/issues/92282
    cpu = case Hardware.oldest_cpu
    when :arm_vortex_tempest then "apple_m1" # See `zig targets`.
    else Hardware.oldest_cpu
    end

    args = []
    args << "-Dcpu=#{cpu}" if build.bottle?

    system "zig", "build", *std_zig_args, *args
  end

  test do
    # fancy-cat is a TUI application, unfortunately we cannot test it properly
    assert_match version.to_s, shell_output("#{bin}/fancy-cat --version")
  end
end
