class Mercury < Formula
  desc "Logic/functional programming language"
  homepage "https://mercurylang.org/"
  url "https://dl.mercurylang.org/release/mercury-srcdist-20.06.tar.gz"
  sha256 "b9c6965d41af49b4218d2444440c4860630d6f50c18dc6f1f4f8374d114f79be"
  license all_of: ["GPL-2.0-only", "LGPL-2.0-only", "MIT"]

  bottle do
    cellar :any
    rebuild 1
    sha256 "2b02e97a19000e9c576fdd5c48b29300e210b9464fff7a0b7b68879555b9723b" => :big_sur
    sha256 "ede7304ce96165ca6382118eacb3997e0732b875db721640002d203db9e66346" => :catalina
    sha256 "ac95cc73104a5621d7a561ae9957561206541633bff5adaf22ed36e21517add1" => :mojave
    sha256 "60240308ebcc05ca33a4d40a787745cd4f60b445c9d94302505253bfd4697f6f" => :high_sierra
  end

  depends_on "openjdk"

  # Disable advanced segfault handling due to broken header detection.
  patch do
    url "https://github.com/Mercury-Language/mercury/commit/37ed70d43878cd53c8da40bf410e0a312835c036.patch?full_index=1"
    sha256 "f01aca048464341dcf6e345056050e2c45236839cca17ac01fc944131d1641c0"
  end

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
