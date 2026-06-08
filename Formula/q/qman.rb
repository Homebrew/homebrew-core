class Qman < Formula
  desc "Modern man page viewer"
  homepage "https://github.com/plp13/qman"
  url "https://github.com/plp13/qman/archive/refs/tags/v1.5.1.tar.gz"
  sha256 "e550958523d0fef90fd0123a61a8f10099ed0c9735e06d8152662d8965b5a0e1"
  license "BSD-2-Clause"

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "e07746ea2c127a2ce52d95614a7ef968ee4a6866b4c22ff72129e63b93920cbd"
    sha256 arm64_sequoia: "b9860b41ec038ef4e8ee10a812061d10200e79de99aa688b98c6e708e44e52f6"
    sha256 arm64_sonoma:  "46bb05e8e49aadf92530d47b2d2a232826406130cf59ec48555ca6558149d8a5"
    sha256 sonoma:        "5d8f23437a7b249837f535f648c341a1e7a66aa33a78986c2d0cf79056b25569"
    sha256 arm64_linux:   "7edfe4210247f8336d79e9bac0da7d0e45c8acfdc87299affa0d6f631c292a5c"
    sha256 x86_64_linux:  "035e634ee3b22a3e192c0279af1cc41c4b33b6e2a43d96712a01e27a382c0943"
  end

  depends_on "cogapp" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "groff"
  depends_on "ncurses"

  on_linux do
    depends_on "man-db" => :test
    depends_on "libbsd"
    depends_on "zlib-ng-compat"
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
