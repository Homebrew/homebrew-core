class Mafft < Formula
  desc "Multiple alignments with fast Fourier transforms"
  homepage "https://mafft.cbrc.jp/alignment/software/"
  url "https://mafft.cbrc.jp/alignment/software/mafft-7.313-with-extensions-src.tgz"
  sha256 "c48e5e05b427cae0d862daaef6148675d5ef57e24425c17b4c3d8da5b060eabd"

  depends_on :macos => :lion

  def install
    make_args = %W[CC=#{ENV.cc} CXX=#{ENV.cxx} CFAGS=#{ENV.cflags}
                   CXXFLAGS=#{ENV.cxxflags} PREFIX=#{prefix} MANDIR=#{man1}
                   install]

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
