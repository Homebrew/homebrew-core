class Mercury < Formula
  desc "Logic/functional programming language"
  homepage "https://mercurylang.org/"
  url "https://dl.mercurylang.org/release/mercury-srcdist-22.01.2.tar.gz"
  sha256 "a8f92f5b916c2a333101bcad2e2c405a527b8c4ec7fdd1cfd973f9f4f6ab17e8"
  license all_of: ["GPL-2.0-only", "LGPL-2.0-only", "MIT"]

  livecheck do
    url "https://dl.mercurylang.org/"
    regex(/href=.*?mercury-srcdist[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "855df991955baffa567fca232ebdb85a3ebc14ca0c1405f83cc40e77956351a2"
    sha256 cellar: :any,                 arm64_big_sur:  "c938ab8e2686d03733c01caea06501b694e4fe4cca085613bdef63453a80ec10"
    sha256 cellar: :any,                 monterey:       "54bb5d0f1ef77ef257ea5a8f05f4d2f9f8e55f4bebf519c3efc2f27315587db5"
    sha256 cellar: :any,                 big_sur:        "873560ec1a1567db5ae42f751484facc58adce98a99a40372819289bf53bfe56"
    sha256 cellar: :any,                 catalina:       "e004bccc8b21de16e6c81c96494921b25e03b5e2cb7f20247bfef381be6c3051"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9224ed7953a854a9d69ceebf9af5696f41268d61f6916a2a103296d5ae1a5ea7"
  end

  depends_on "openjdk"

  uses_from_macos "flex"

  def install
    system "./configure", "--prefix=#{prefix}",
            "--mandir=#{man}",
            "--infodir=#{info}",
            "mercury_cv_is_littleender=yes" # Fix broken endianness detection

    system "make", "install", "PARALLEL=-j"

    # Remove batch files for windows.
    rm Dir.glob("#{bin}/*.bat")
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

    system "#{bin}/mmc", "-o", "hello_c", "hello"
    assert_predicate testpath/"hello_c", :exist?

    assert_equal test_string, shell_output("#{testpath}/hello_c")

    system "#{bin}/mmc", "--grade", "java", "hello"
    assert_predicate testpath/"hello", :exist?

    assert_equal test_string, shell_output("#{testpath}/hello")
  end
end
