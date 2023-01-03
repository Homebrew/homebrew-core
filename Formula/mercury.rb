class Mercury < Formula
  desc "Logic/functional programming language"
  homepage "https://mercurylang.org/"
  url "https://dl.mercurylang.org/release/mercury-srcdist-22.01.5.tar.gz"
  sha256 "7e1b2d1b130c0afc65542be3c2e48399cf2c25d7a04ad3c427e022715b098a0f"
  license all_of: ["GPL-2.0-only", "LGPL-2.0-only", "MIT"]

  livecheck do
    url "https://dl.mercurylang.org/"
    regex(/href=.*?mercury-srcdist[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "0751d295215f349b480049b531576e69943beb12477ee6b66feb7a816b213c26"
    sha256 cellar: :any,                 arm64_monterey: "9727730ebd3fa36ac4f44960986364650e1ea06771a7d3356623fc8cce4d4920"
    sha256 cellar: :any,                 arm64_big_sur:  "c14ccd7d01b08b7613ad00b533f2e894211fc022cdb2430c1b6a253df4b637ba"
    sha256 cellar: :any,                 ventura:        "7d6067caaba5b3702925281372829d2335032c60d0ba3d5b8c4bb079af41875c"
    sha256 cellar: :any,                 monterey:       "5a85170167d479402b417a97f546224e1b60bb14703994afadf4564aa812659e"
    sha256 cellar: :any,                 big_sur:        "66fc23eb80ac2fd0c82ca3dcc375cde9e6be66973576f0ed1312b83630c96fbc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bc7c9dc9c7c47729b296ed1f09073aa1d21169b3552cd784c1c1d287d28ac7db"
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
