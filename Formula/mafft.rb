class Mafft < Formula
  desc "Multiple alignments with fast Fourier transforms"
  homepage "https://mafft.cbrc.jp/alignment/software/"
  url "https://mafft.cbrc.jp/alignment/software/mafft-7.313-with-extensions-src.tgz"
  sha256 "c48e5e05b427cae0d862daaef6148675d5ef57e24425c17b4c3d8da5b060eabd"

  fails_with :clang do
    build 421
    cause <<-EOS
      Clang does not allow default arguments in out-of-line definitions of
      class template members.
      EOS
  end

  def install
    make_args = %W[CC=#{ENV.cc} CXX=#{ENV.cxx} CFAGS=#{ENV.cflags}
                   CXXFLAGS=#{ENV.cxxflags} PREFIX=#{prefix} MANDIR=#{man1}]
    make_args << "ENABLE_MULTITHREAD=" if MacOS.version <= :snow_leopard
    make_args << "install"

    cd "core" do
      system "make", *make_args
    end

    cd "extensions" do
      system "make", *make_args
    end
  end

  def caveats
    if MacOS.version <= :snow_leopard
      <<-EOS
        This build of MAFFT is not multithreaded on Snow Leopard
        because its compiler does not support thread-local storage.
      EOS
    end
  end

  test do
    (testpath/"test.fa").write ">1\nA\n>2\nA"
    system "#{bin}/mafft", "test.fa"
  end
end
