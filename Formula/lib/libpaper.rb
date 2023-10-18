class Libpaper < Formula
  desc "Library for handling paper characteristics"
  homepage "https://github.com/rrthomas/libpaper"
  url "https://github.com/rrthomas/libpaper/releases/download/v2.1.2/libpaper-2.1.2.tar.gz"
  sha256 "1fda0cf64efa46b9684a4ccc17df4386c4cc83254805419222c064bf62ea001f"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_sonoma:   "40d5e57b61b3606c26e76611ebc7dd719072b0f9d0e783730d2b475b419fca29"
    sha256 arm64_ventura:  "d86231b8db9f0662118f70093da6bf4f7c8512cf532a11022fc2a28434421d9b"
    sha256 arm64_monterey: "f03b1f17235b3943ca8b1a04f4388be62cb78faea544297fbd0eda9709c83f26"
    sha256 sonoma:         "b446d9c95fa8abacb1043ac4f93201512105edfdfab4ed7582168035acf7cd4b"
    sha256 ventura:        "d54d8e9249b4cb04db162012efdc2502ee8835083a021e2d73ee246f581ee7e5"
    sha256 monterey:       "17115a679c08d1d16f2658b4c318a26d2343e5a17af3e8b64bdffada4022728a"
    sha256 x86_64_linux:   "6048d20dc945d54c9e40b8351ac580a0dfef3ec0aebd73a9c56a2dc1c89ae159"
  end

  depends_on "help2man" => :build

  def install
    system "./configure", *std_configure_args, "--sysconfdir=#{etc}"
    system "make", "install"
  end

  test do
    assert_match "A4: 210x297 mm", shell_output("#{bin}/paper --all")
    assert_match "paper #{version}", shell_output("#{bin}/paper --version")

    (testpath/"test.c").write <<~EOS
      #include <paper.h>
      int main()
      {
        enum paper_unit unit;
        int ret = paperinit();
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lpaper", "-o", "test"
    system "./test"
  end
end
