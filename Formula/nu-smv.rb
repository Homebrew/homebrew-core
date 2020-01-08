class NuSmv < Formula
  desc "Reimplementation and extension of SMV symbolic model checker"
  homepage "http://nusmv.fbk.eu"
  url "http://nusmv.fbk.eu/distrib/NuSMV-2.6.0.tar.gz"
  sha256 "dba953ed6e69965a68cd4992f9cdac6c449a3d15bf60d200f704d3a02e4bbcbb"

  bottle do
    cellar :any_skip_relocation
    sha256 "90dad1b30d80ee7ddba984d6ad2536fff08896e79cf1a26a083a5e9990fc3c43" => :catalina
    sha256 "c2cc207758d6f315db1116e0e162be72edc0356312c460cd3359dca8c7de597e" => :mojave
    sha256 "f2e93143e60b64244fd25958a88480acee332fd4109a6bd356719dc6259efc36" => :high_sierra
    sha256 "64f825eac53c6c16c9b3db4b505d37a6de9f1f3471863b39081b5a98d517fb3e" => :sierra
  end

  depends_on "cmake" => :build

  def install
    mkdir "NuSMV/build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    (testpath/"test.smv").write <<~EOS
      MODULE main
      SPEC TRUE = TRUE
    EOS

    output = shell_output("#{bin}/NuSMV test.smv")
    assert_match "specification TRUE = TRUE  is true", output
  end
end
