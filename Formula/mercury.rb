class Mercury < Formula
  desc "Logic/functional programming language"
  homepage "https://mercurylang.org/"
  url "https://dl.mercurylang.org/release/mercury-srcdist-22.01.6.tar.gz"
  sha256 "769456f834462593c8bd4bfaff2d532c0163acf3a574a06da709fcee73a022df"
  license all_of: ["GPL-2.0-only", "LGPL-2.0-only", "MIT"]

  livecheck do
    url "https://dl.mercurylang.org/"
    regex(/href=.*?mercury-srcdist[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "ccc6180723f3322a165922ff53c6aa0702fa904395d0f80c150e108ecf8ae965"
    sha256 cellar: :any,                 arm64_monterey: "eef2b6ed90d1af0459761db3849274bd849446a0694804ccff1446751674411f"
    sha256 cellar: :any,                 arm64_big_sur:  "61c3fcf3ec23b69e75505748edbe84b5af45deff3b5a9506b48ab324d4061953"
    sha256 cellar: :any,                 ventura:        "63fc3adae874783b66da97ae9b106bc19cf408347852adcc6e9ef6e11356aa4d"
    sha256 cellar: :any,                 monterey:       "d11eff6609ed3c59b4f3843994acb15823f74bd0a1d1e762b3ce028491555cfc"
    sha256 cellar: :any,                 big_sur:        "01160431cdfa126230ecb8939d54dce7cc3baacbfcdf833cc365cfab4ac04fa6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "82dc643fbabba12c93ddbe2f4826c66a07b0903219839541edfbe343c9415579"
  end

  depends_on "openjdk"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--infodir=#{info}",
                          "mercury_cv_is_littleender=yes" # Fix broken endianness detection
    system "make", "install", "PARALLEL=-j"

    # Remove batch files for windows.
    bin.glob("*.bat").map(&:unlink)
  end

  test do
    test_string = "Hello Homebrew\n"
    path = testpath/"hello.m"
    path.write <<~EOS
      :- module hello.
      :- interface.
      :- import_module io.
      :- pred main(io::di, io::uo) is det.
      :- implementation.
      main(IOState_in, IOState_out) :-
          io.write_string("#{test_string}", IOState_in, IOState_out).
    EOS

    system bin/"mmc", "-o", "hello_c", "hello"
    assert_predicate testpath/"hello_c", :exist?

    assert_equal test_string, shell_output("#{testpath}/hello_c")

    system bin/"mmc", "--grade", "java", "hello"
    assert_predicate testpath/"hello", :exist?

    assert_equal test_string, shell_output("#{testpath}/hello")
  end
end
