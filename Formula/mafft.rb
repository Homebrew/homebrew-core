class Mafft < Formula
  desc "Multiple alignments with fast Fourier transforms"
  homepage "https://mafft.cbrc.jp/alignment/software/"
  url "https://mafft.cbrc.jp/alignment/software/mafft-7.313-with-extensions-src.tgz"
  sha256 "c48e5e05b427cae0d862daaef6148675d5ef57e24425c17b4c3d8da5b060eabd"

  bottle do
    cellar :any_skip_relocation
    sha256 "823d5ae47d74dae6111ccbfc2dcd55f0ea3bfc956611633734a3d8ac3ac004a5" => :high_sierra
    sha256 "966cfbb27be12a9d0fd0bda110fe112828225f5ebfc3b9eeb416314c97282ac1" => :sierra
    sha256 "ecba2c513890512392db67b4832d9f70d0ea7dd52db9832e7c508764a7d93c76" => :el_capitan
  end

  depends_on :macos => :lion

  def install
    make_args = %W[CC=#{ENV.cc} CXX=#{ENV.cxx} PREFIX=#{prefix} install]

    cd "core" do
      system "make", *make_args
    end

    cd "extensions" do
      system "make", *make_args
    end
  end

  test do
    (testpath/"test.fa").write ">1\nA\n>2\nA"
    output = shell_output("#{bin}/mafft test.fa")
    assert_match ">1\na\n>2\na", output
  end
end
