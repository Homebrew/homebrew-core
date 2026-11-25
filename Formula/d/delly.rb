class Delly < Formula
  desc "Structural variant discovery by paired-end and split-read analysis"
  homepage "https://github.com/dellytools/delly"
  url "https://github.com/dellytools/delly/archive/refs/tags/v2.8.2.tar.gz"
  sha256 "9c870926df96772cca1f784aa3e92adfb2b0f510734f1c05fb197045077150e1"
  license "BSD-3-Clause"
  head "https://github.com/dellytools/delly.git", branch: "main"

  bottle do
    rebuild 1
    manifest_sha256 "b1548a73ca0c8a2b85fbd07163949a064ec7f937fe636246c19b6a4b9bf1bb79"
    sha256 cellar: :any, arm64_golden_gate: "5243e32e929ff74b09dece73e9d2cf5d94b74fc6caecfb4a80e606add2a38884"
    sha256 cellar: :any, arm64_tahoe:       "a019bfdd37cb0d21c411005f94f51fd879528ffb7cd6413dc8caaab6dcee7654"
    sha256 cellar: :any, arm64_sequoia:     "427afeb21102c4119baa294eb4fe78131122db1abb3fe9855527e5d42ea32e0f"
    sha256 cellar: :any, arm64_linux:       "d1263eb911c68074cdea0171aa49d370f79fd31766a150c599a0897851edef56"
    sha256 cellar: :any, x86_64_linux:      "241398d36826caf2f30e105331b229c70630eb1694fcbb35db23876f857b1916"
  end

  depends_on "boost"
  depends_on "htslib"

  deny_network_access!

  def install
    ENV.append "LDFLAGS", "-Wl,-dead_strip_dylibs" if OS.mac? # reduce overlinking

    system "make", "src/delly",
           "HTSLIBINCDIR=#{formula_opt_include("htslib")}",
           "HTSLIBLIBDIR=#{formula_opt_lib("htslib")}",
           "BOOSTINCDIR=#{formula_opt_include("boost")}",
           "BOOSTLIBDIR=#{formula_opt_lib("boost")}"
    bin.install "src/delly"
    pkgshare.install %w[example R scripts]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/delly --version 2>&1")
    system bin/"delly", "lr", "-g", pkgshare/"example/ref.fa", "-o", testpath/"lr.bcf", pkgshare/"example/lr.bam"
    assert_path_exists testpath/"lr.bcf"
  end
end
