class Adapterremoval < Formula
  desc "Rapid adapter trimming, identification, and read merging"
  homepage "https://github.com/MikkelSchubert/adapterremoval"
  url "https://github.com/MikkelSchubert/adapterremoval/archive/refs/tags/v3.0.0.tar.gz"
  sha256 "08145e38f27bfd94e9c95864365726bc63e9325a8b39b973b9ab6c87bd8c93aa"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "fe1f1b3ee47637eca94d1e08efdd98d452c373e338518202f78e7b5ecafc4ef0"
    sha256 cellar: :any, arm64_sequoia: "d202010da68e584d3129e665b66cc10942b0319cb0a97826b4f526c9b68927c8"
    sha256 cellar: :any, arm64_sonoma:  "db968108511cdf67f166eeb60823e76beba3d6b4c2a769705690c9b7cf09c78b"
    sha256 cellar: :any, sonoma:        "52e49e70013942cb39655695d982f7790fc1e3ece0901e74328856dbc637d6eb"
    sha256               arm64_linux:   "14ac480c9aa9681e7da56ef0a6d5a4621432a296563db875a39bc8c37eb26e30"
    sha256               x86_64_linux:  "e00c540f071ee2aee4f4bd0d9bd8df53efcbeafc90b6602ab1ccce7308139368"
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
