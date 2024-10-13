class Mercury < Formula
  desc "Logic/functional programming language"
  homepage "https://mercurylang.org/"
  url "https://dl.mercurylang.org/release/mercury-srcdist-22.01.8.tar.gz"
  sha256 "a097e8cc8eca0152ed9527c1caf73e5c9c83f6ada1d313a25b80fe79072fbad8"
  license all_of: ["GPL-2.0-only", "LGPL-2.0-only", "MIT"]

  livecheck do
    url "https://dl.mercurylang.org/"
    regex(/href=.*?mercury-srcdist[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "5b4083720e56ac9ae01b892e3e33658db3c236f16923155bb8d06f8ebaa46934"
    sha256 cellar: :any,                 arm64_sonoma:   "19316e06cb23c30511f3e6698a7794659091ee7f8606103a9db54b56fbfff732"
    sha256 cellar: :any,                 arm64_ventura:  "2b8d7c98d918811a42e554b8a8528d2e92fa318abd0aa09e9af0379e2df76081"
    sha256 cellar: :any,                 arm64_monterey: "50dec0a2072f226596bdfbdf395f99b102f7a65f66ce96a2f045ba68e0f2780d"
    sha256 cellar: :any,                 arm64_big_sur:  "11ca6af6293cfe4739d4d4b7afac1a923a805431f892f2b217cb575abe4a9c9b"
    sha256 cellar: :any,                 sonoma:         "d79560ef5d6e2f9c0fb5fe44f6e65429ab007e4e30e4442f929647d24e3e9b05"
    sha256 cellar: :any,                 ventura:        "3a2c5813d314b54387d4e48e35ebc92256a0caed5af9ee3a254c31a43a5e37c4"
    sha256 cellar: :any,                 monterey:       "8479fd7c8fbf9f807f2062ad76f3cf53e1e10d5ae81a41d2cf48c5657d91b0ef"
    sha256 cellar: :any,                 big_sur:        "fab2615bf575b450892b66f2ff28a2b5c82da34026b11b4875dc2e9db607058d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a808ee3d86cc43a43890838ce0bf4ca70f30471173d5ce78126f4d0d632f96a8"
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
