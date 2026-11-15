class Mosdepth < Formula
  desc "Fast BAM/CRAM depth calculation for WGS, exome, or targeted sequencing"
  homepage "https://github.com/brentp/mosdepth"
  url "https://github.com/brentp/mosdepth/archive/refs/tags/v0.3.15.tar.gz"
  sha256 "7fc4bacd5cd1fecad76c93f08921e32efaad2ebabccd7a65e6f4fdf9095ea08e"
  license "MIT"
  head "https://github.com/brentp/mosdepth.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "aca29bbd3d039122e9fb5ee700c758d2d31a88ffaa40ef083b8e07b5580a4876"
    sha256 cellar: :any, arm64_tahoe:       "6fbc754534b3214dac991c1ff6462e3d2c0076ab6398b98f0e26ce174bcbf137"
    sha256 cellar: :any, arm64_sequoia:     "34f181713614749647b2b7e301b6cdfed540983ef5a81bc6081827b01686d7ec"
    sha256 cellar: :any, arm64_linux:       "b5986e1b5fe8cb3ac41b162edecfbd51bf49848444737f5cc17617061491ffec"
    sha256 cellar: :any, x86_64_linux:      "a517cad427a2e1c7129ae2757ff28e6ea17b5d11c1d5c9f276e553637cbc6ef6"
  end

  depends_on "nim" => :build
  depends_on "samtools" => :test
  depends_on "htslib"

  # Nim library dependencies, resolved offline instead of via `nimble`.
  # d4 output is intentionally omitted: it needs the out-of-core d4 library,
  # so mosdepth is built without `-d:d4` (all other functionality is present).
  resource "hts-nim" do
    url "https://github.com/brentp/hts-nim/archive/refs/tags/v0.3.32.tar.gz"
    sha256 "98eb4da6140e61e1383946b77451b684865d8b7ea00ddc17a4bf331ee171892d"

    livecheck do
      url :url
    end
  end

  resource "docopt" do
    url "https://github.com/docopt/docopt.nim/archive/refs/tags/v0.7.1.tar.gz"
    sha256 "a172f7e8be5c10735727ca00f69294e8615c4ad055dd9b58dcdb0f7c6bd7d025"

    # mosdepth pins an exact docopt version
    livecheck do
      url "https://raw.githubusercontent.com/brentp/mosdepth/refs/tags/v#{LATEST_VERSION}/mosdepth.nimble"
      regex(/docopt\s*==\s*v?(\d+(?:\.\d+)+)/i)
    end
  end

  resource "regex" do
    url "https://github.com/nitely/nim-regex/archive/refs/tags/v0.27.0.tar.gz"
    sha256 "3132a9c3f04b1b8b8ded14228062c815b083d475ab30006fd66604e9484dc47c"

    livecheck do
      url :url
    end
  end

  resource "unicodedb" do
    url "https://github.com/nitely/nim-unicodedb/archive/refs/tags/v0.14.1.tar.gz"
    sha256 "dc2861b9e19feab099695aa49ffae37f1a3fd1930a536e67ddc02dd917ba560e"

    livecheck do
      url :url
    end
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
