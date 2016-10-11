class Mercury < Formula
  desc "Logic/functional programming language"
  homepage "https://mercurylang.org/"
  url "https://dl.mercurylang.org/release/mercury-srcdist-14.01.1.tar.gz"
  sha256 "98f7cbde7a7425365400feef3e69f1d6a848b25dc56ba959050523d546c4e88b"
  revision 1

  bottle do
    cellar :any
    sha256 "200fbd8b1e59fa3b4b7ef80d09955c697a31e83f15eb4c661bef1dc2458236d0" => :sierra
    sha256 "daf916b14c3358f4d7ed6cdba153f96d6f4acec2d29b9fb43b027a6610bd783d" => :el_capitan
    sha256 "afcff5ed87fdd477ce8037cca2f3fcab828b71cf78e1fbde951c4e17ae3e0b17" => :yosemite
    sha256 "0e736ef6f5cc48bc9d6f7d50cb9df6fb52dba2b0b3bf2d83b378f83fcff4ecb9" => :mavericks
  end

  depends_on "erlang" => :optional
  depends_on "homebrew/science/hwloc" => :optional
  depends_on "mono" => :optional

  def install
    args = ["--prefix=#{prefix}",
            "--mandir=#{man}",
            "--infodir=#{info}",
            "--disable-dependency-tracking",
            "--enable-java-grade"]

    args << "--enable-erlang-grade" if build.with? "erlang"
    args << "--with-hwloc" if build.with? "hwloc"
    args << "--enable-csharp-grade" if build.with? "mono"

    system "./configure", *args

    # The build system doesn't quite honour the mandir/infodir autoconf
    # parameters.
    system "make", "install", "PARALLEL=-j",
                              "INSTALL_MAN_DIR=#{man}",
                              "INSTALL_INFO_DIR=#{info}"

    # Remove batch files for windows.
    rm Dir.glob("#{bin}/*.bat")
  end

  test do
    test_string = "Hello Homebrew\n"
    path = testpath/"hello.m"
    path.write <<-EOS
      :- module hello.
      :- interface.
      :- import_module io.
      :- pred main(io::di, io::uo) is det.
      :- implementation.
      main(IOState_in, IOState_out) :-
          io.write_string("#{test_string}", IOState_in, IOState_out).
    EOS
    system "#{bin}/mmc", "--make", "hello"
    assert File.exist?(testpath/"hello")

    assert_equal test_string, shell_output("#{testpath}/hello")
  end
end
