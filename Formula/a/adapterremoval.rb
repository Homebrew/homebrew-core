class Adapterremoval < Formula
  desc "Rapid adapter trimming, identification, and read merging"
  homepage "https://github.com/MikkelSchubert/adapterremoval"
  url "https://github.com/MikkelSchubert/adapterremoval/archive/refs/tags/v3.0.2.tar.gz"
  sha256 "905f7c3289f743a90d228226ad6a50aec101343830bfdef5608ec9bb69af0ca7"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "ef915d8223ce4dc9d1a2ba7b67fabd01b75fc08cfa0830f48ffb6c757f3204fb"
    sha256 cellar: :any, arm64_sequoia: "5c00a2d2b507a17d9d569eb247a2dfdef49b5c3ac3b073f920c23abaaf05ea34"
    sha256 cellar: :any, arm64_sonoma:  "0808fd52d51e7b1ef9664120fbdf203f7910de67279b1c7c45e50c4a49e0aa2d"
    sha256 cellar: :any, sonoma:        "06ca0d1c4b56b3a8f5ee607926a151e261f0e92bb77265640bb5bf4e8fec5d1b"
    sha256               arm64_linux:   "c9d06e27db10962db51126eddcd4254d40181564f6cda562cf1196ac4f6a881f"
    sha256               x86_64_linux:  "9457322cda074f23c4965f72e6f3d51ab42767c47df8fa35d4bdf62b2de955df"
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
    args = %w[
      -Db_coverage=false
      -Db_lto=false
      -Db_lto_mode=thin
      -Ddebug=false
      -Dmanpage=enabled
      -Ddocs=disabled
      -Duv=auto
      -Dharden=true
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
