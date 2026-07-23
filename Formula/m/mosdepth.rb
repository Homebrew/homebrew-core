class Mosdepth < Formula
  desc "Fast BAM/CRAM depth calculation for WGS, exome, or targeted sequencing"
  homepage "https://github.com/brentp/mosdepth"
  url "https://github.com/brentp/mosdepth/archive/refs/tags/v0.3.14.tar.gz"
  sha256 "abac67de4547dc5642efd46846044d6b3536d2ca3443b4ca172446edf82eeb42"
  license "MIT"
  head "https://github.com/brentp/mosdepth.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "ab01db3acd22d1cb686cdb38ff9cc5a432c86d843c04af34a5c08a75f5c0030b"
    sha256 cellar: :any, arm64_sequoia: "cffc3d89b425592fda027bf10f79ca40419d1c8a037ea215f9ba44d465c445c4"
    sha256 cellar: :any, arm64_sonoma:  "aea014b3b89a1d585eed3624c034b6017fbbd52e255c64262a87c9b348de1dc4"
    sha256 cellar: :any, sonoma:        "3cfae40cc1b231281f7742897a8aab277efe32d41c8ae8d4a9bc62795104158c"
    sha256 cellar: :any, arm64_linux:   "efb4b8a4114263f90c64e5169327da64957e3e2df160475beb13194c21ef4945"
    sha256 cellar: :any, x86_64_linux:  "7b2f09e1fab11ee2e00ba6f2c5df342cd6c3095f8f92197ffbe12bb1b04fa7ac"
  end

  depends_on "nim" => :build
  depends_on "samtools" => :test
  depends_on "htslib"

  # Nim library dependencies, resolved offline instead of via `nimble`.
  # d4 output is intentionally omitted: it needs the out-of-core d4 library,
  # so mosdepth is built without `-d:d4` (all other functionality is present).
  resource "hts-nim" do
    url "https://github.com/brentp/hts-nim/archive/refs/tags/v0.3.31.tar.gz"
    sha256 "e2e8572156cced4557fcb75ecf5a7ee072bcc7abf81066d4b54d5bf674dab3e0"
  end

  resource "docopt" do
    url "https://github.com/docopt/docopt.nim/archive/refs/tags/v0.7.1.tar.gz"
    sha256 "a172f7e8be5c10735727ca00f69294e8615c4ad055dd9b58dcdb0f7c6bd7d025"
  end

  resource "regex" do
    url "https://github.com/nitely/nim-regex/archive/refs/tags/v0.26.3.tar.gz"
    sha256 "f237ca8e162cd203c5530f0ca05c0dc3b00288ee190d8ad8efba45cd51a2d4d6"
  end

  resource "unicodedb" do
    url "https://github.com/nitely/nim-unicodedb/archive/refs/tags/v0.13.2.tar.gz"
    sha256 "61a994fbdc3f3596e5dd663ca17fe585726da5c5b7059e437087787b3aa9aae2"
  end

  def install
    vendor = buildpath/"vendor"
    deps = %w[hts-nim docopt regex unicodedb]
    deps.each { |r| resource(r).stage(vendor/r) }

    htslib = Formula["htslib"]
    args = deps.map { |r| "--path:#{vendor}/#{r}/src" }
    args += [
      "--passC:-I#{htslib.opt_include}",
      "--passL:-L#{htslib.opt_lib}",
      "--passL:-lhts",
      "--passL:-Wl,-rpath,#{rpath(target: htslib.opt_lib)}",
      "--dynlibOverride:hts",
    ]

    system "nim", "c", "-d:release", "--opt:speed", "--threads:on", "--mm:refc",
           *args, "-o:#{bin}/mosdepth", "mosdepth.nim"
  end

  test do
    sam = [
      "@HD\tVN:1.6\tSO:coordinate",
      "@SQ\tSN:chr1\tLN:1000",
      "r1\t0\tchr1\t10\t60\t10M\t*\t0\t0\tACGTACGTAC\tIIIIIIIIII",
      "r2\t0\tchr1\t20\t60\t10M\t*\t0\t0\tACGTACGTAC\tIIIIIIIIII",
      "r3\t0\tchr1\t25\t60\t10M\t*\t0\t0\tACGTACGTAC\tIIIIIIIIII",
    ].join("\n")
    (testpath/"reads.sam").write "#{sam}\n"

    samtools = formula_opt_bin("samtools")/"samtools"
    system samtools, "sort", "-o", "reads.bam", "reads.sam"
    system samtools, "index", "reads.bam"

    system bin/"mosdepth", "--no-per-base", "sample", "reads.bam"
    summary = (testpath/"sample.mosdepth.summary.txt").read
    assert_match "chr1\t1000\t30", summary

    assert_match version.to_s, shell_output("#{bin}/mosdepth --version 2>&1")
  end
end
