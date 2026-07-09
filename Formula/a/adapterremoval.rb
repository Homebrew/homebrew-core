class Adapterremoval < Formula
  desc "Rapid adapter trimming, identification, and read merging"
  homepage "https://github.com/MikkelSchubert/adapterremoval"
  url "https://github.com/MikkelSchubert/adapterremoval/archive/refs/tags/v3.0.1.tar.gz"
  sha256 "52bef5e9ad5de76a6bd0a1522ad621e95efec0cc23602900bd65a154f96a1f6e"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "d356ce191bce3d4637afe7f018731f5790e4e0331c54c6cbe41198196ad3017a"
    sha256 cellar: :any, arm64_sequoia: "4aa3febe3500b531e7ab1bbea48a9cf00a3c59168cca2b2dc63a440e76ce2b89"
    sha256 cellar: :any, arm64_sonoma:  "e54735ba61b7158e27e0f4851e47e9040a7cf34817f476124510217ab3e8a152"
    sha256 cellar: :any, sonoma:        "4dfcb73fde9c3aa038c879d8a223dfa88bc7f42b2eaf39af6480b5fe5d42bd1e"
    sha256               arm64_linux:   "dac7c85e227d8a27aeaa348a7cfddf2ca8bdbe0ec9fc9589aba0f75f16655730"
    sha256               x86_64_linux:  "2f209a14c5e416b0fde6637cb8fe53fd6104d0b689374d1f97399bcccb08a0aa"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "sphinx-doc" => :build
  depends_on "isa-l"
  depends_on "libdeflate"

  uses_from_macos "python" => :build

  on_linux do
    depends_on "zlib-ng-compat"
  end

  deny_network_access!

  def install
    # macOS SDK < 15 lacks quick_exit
    if OS.mac? && DevelopmentTools.clang_build_version < 1700
      inreplace "src/main.cpp", "std::quick_exit(1);", "std::_Exit(1);"
    end

    args = %w[
      -Db_coverage=false
      -Db_lto=false
      -Db_lto_mode=thin
      -Ddebug=false
      -Dmanpage=enabled
      -Ddocs=disabled
      -Duv=auto
      -Dharden=true
      -Dmimalloc=disabled
      -Dstatic=false
    ]
    system "meson", "setup", "build", *args, *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"

    pkgshare.install share/"adapterremoval3/examples"
  end

  test do
    examples = pkgshare/"examples"
    args = %W[
      --in-file1 #{examples}/reads_1.fastq
      --in-file2 #{examples}/reads_2.fastq
      --out-prefix #{testpath}/output
    ].join(" ")

    assert_match "Processed 1,000 reads", shell_output("#{bin}/adapterremoval3 #{args} 2>&1")
  end
end
