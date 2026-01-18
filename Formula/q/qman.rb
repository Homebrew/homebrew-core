class Qman < Formula
  desc "Modern man page viewer"
  homepage "https://github.com/plp13/qman"
  url "https://github.com/plp13/qman/archive/refs/tags/v1.5.1.tar.gz"
  sha256 "e550958523d0fef90fd0123a61a8f10099ed0c9735e06d8152662d8965b5a0e1"
  license "BSD-2-Clause"

  bottle do
    sha256 arm64_tahoe:   "474565b62a04136b4c671d9ef6f7ff126bc5d31627a09c7903522cb517a9b89c"
    sha256 arm64_sequoia: "998e6360a22025e0ca4565178f41038e38848b859b09cae6f51d89ad9ed9d765"
    sha256 arm64_sonoma:  "b09e71d35bd2f8152b1a0aa686286e76882d3cafb83d153a7f37e372c1f03653"
    sha256 sonoma:        "5dd30d9d62b7f12dc6c4e0ea0c6d78062c66fbbaf9e0ec568b069fa2fb9e35cd"
    sha256 arm64_linux:   "66cb799fe63e479fa0e912354de09ae9b30f44aed24c8750589f5a0826c2f58e"
    sha256 x86_64_linux:  "7a5205746e5f2dfd2ef241e9c279dc20dce11c6b58ae6ac32ecdcb526b78bc4a"
  end

  depends_on "cogapp" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "groff"
  depends_on "ncurses"

  uses_from_macos "zlib"

  on_linux do
    depends_on "man-db" => :test
    depends_on "libbsd"
  end

  def install
    args = %W[
      -Dtests=disabled
      -Dbzip2=disabled
      -Dlzma=disabled
      -Dconfigdir=#{pkgetc}
    ]
    args += %w[-Dlibbsd=enabled] if OS.linux?

    system "meson", "setup", "build", *args, *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"

    systype = if OS.mac?
      "darwin"
    else
      "mandb"
    end
    inreplace pkgetc/"qman.conf", "[misc]", <<~EOS
      [misc]
      system_type=#{systype}
      groff_path=#{Formula["groff"].opt_bin}/groff
    EOS
  end

  test do
    match_str = "more modern manual page viewer"
    result = 0

    # Linux CI has no man-related support files
    opts = if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]
      cp_r pkgetc, testpath/"qman"
      inreplace testpath/"qman/qman.conf", "[misc]", <<-EOS
        [misc]
        whatis_path=#{Formula["man-db"].opt_bin}/gwhatis
        apropos_path=#{Formula["man-db"].opt_bin}/gapropos
      EOS
      match_str = "This system has been minimized by removing packages and content"
      result = 2

      "-C #{testpath}/qman/qman.conf"
    end

    assert_match match_str, shell_output("#{bin}/qman #{opts} -T -l #{man1}/qman.1 2>&1", result)
  end
end
