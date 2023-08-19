class Mercury < Formula
  desc "Logic/functional programming language"
  homepage "https://mercurylang.org/"
  url "https://dl.mercurylang.org/release/mercury-srcdist-22.01.7.tar.gz"
  sha256 "3dcb7254a955d9c9c7a014805e331348fbd663ba29f43ea420cca9603460bc6c"
  license all_of: ["GPL-2.0-only", "LGPL-2.0-only", "MIT"]

  livecheck do
    url "https://dl.mercurylang.org/"
    regex(/href=.*?mercury-srcdist[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "7afc26b366787171fdfe1bcc9763c6f71a715f0fe99df95bbe45456bad7d78d2"
    sha256 cellar: :any,                 arm64_monterey: "18fd673a409296f38c56308835c86fb7e06c0e47341b2293198288ff99ef668a"
    sha256 cellar: :any,                 arm64_big_sur:  "5d884a757ba42c66ce3e3f7e74357ee6cb1799597953e000f01287b00be49864"
    sha256 cellar: :any,                 ventura:        "33eb0f99f3823850b2a2843614b198e9cc5734f51aeb70236d38b04ea3d90644"
    sha256 cellar: :any,                 monterey:       "03498cfa66783219aae7f3cde47727cbaccff836378b3e8d5659e2c8e3e0f017"
    sha256 cellar: :any,                 big_sur:        "adb39bc019dde16d722e763d6f128895059d36c5a7a284f1dfba6b6ff3a502d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fba815d09877283239035cf5861ce08416d3f4d4248afc0efd7dc57466ad9b40"
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
