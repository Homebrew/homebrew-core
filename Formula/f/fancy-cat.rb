class FancyCat < Formula
  desc "PDF reader for terminal emulators using the Kitty image protocol"
  homepage "https://github.com/freref/fancy-cat"
  url "https://github.com/freref/fancy-cat/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "2c6f5bacd5eba701bb9c889f2c613323007a71b9b142d95c9ee62f62110e5aec"
  license "MIT"

  depends_on "zig" => :build
  depends_on "mupdf"

  def install
    # Fix illegal instruction errors when using bottles on older CPUs.
    # https://github.com/Homebrew/homebrew-core/issues/92282
    cpu = case Hardware.oldest_cpu
    when :arm_vortex_tempest then "apple_m1" # See `zig targets`.
    else Hardware.oldest_cpu
    end

    args = %W[
      --prefix #{prefix}
      -Doptimize=ReleaseSafe
    ]

    args << "-Dcpu=#{cpu}" if build.bottle?
    system "zig", "build", *args
  end

  test do
    output_log = testpath/"output.log"
    pid = spawn bin/"fancy-cat", test_fixtures("test.pdf"), [:out, :err] => output_log.to_s
    sleep 2
    assert_match "kitty keyboard capability detected", output_log.read
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
