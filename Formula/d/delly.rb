class Delly < Formula
  desc "Structural variant discovery by paired-end and split-read analysis"
  homepage "https://github.com/dellytools/delly"
  url "https://github.com/dellytools/delly/archive/refs/tags/v2.1.0.tar.gz"
  sha256 "fbc6105489c8cefc94af662b3acbc8b7dd30b3c78a74d59da9982d416dcf584b"
  license "BSD-3-Clause"
  head "https://github.com/dellytools/delly.git", branch: "main"

  depends_on "boost"
  depends_on "htslib"
  depends_on "xz"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  def install
    # Build against Homebrew's htslib and boost instead of the bundled
    # submodules: EBROOTHTSLIB points make at the Homebrew htslib prefix, and
    # the boost include/lib paths are added so the linker finds Homebrew boost.
    ENV.append "CXXFLAGS", "-I#{formula_opt_include("boost")}"
    ENV.append "LDFLAGS", "-L#{formula_opt_lib("htslib")}"
    ENV.append "LDFLAGS", "-L#{formula_opt_lib("boost")}"
    ENV.append "LDFLAGS", "-Wl,-rpath,#{formula_opt_lib("boost")}"

    system "make", "PARALLEL=1", "EBROOTHTSLIB=#{formula_opt_include("htslib")}", "src/delly"
    bin.install "src/delly"
    prefix.install %w[example R scripts]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/delly --version 2>&1")
    system bin/"delly", "call", "-g", prefix/"example/ref.fa", "-o", testpath/"sr.bcf", prefix/"example/sr.bam"
    assert_path_exists testpath/"sr.bcf"
  end
end
