class Icecream < Formula
  desc "Distributed compiler with a central scheduler to share build load"
  homepage "https://en.opensuse.org/Icecream"
  url "https://github.com/icecc/icecream/archive/1.3.1.tar.gz"
  sha256 "9f45510fb2251d818baebcff19051c1cf059e48c6b830fb064a8379480159b9d"
  license "GPL-2.0"

  bottle do
    sha256 arm64_monterey: "6b5da13231142d20828ebd59f265652015450bc61406b0cf15777014cada7ff2"
    sha256 arm64_big_sur:  "649b19fac1c726b6890cd7c106bef0d4b9b065847cb2d40aed20db0467db64f5"
    sha256 monterey:       "6393eb4f02f21856e3a5197fbd5a7b4ba625ec0b8821e2a13aafb898b5493fee"
    sha256 big_sur:        "b8a350fa7f37c1c4c6de9d5570d029ae58566b97e4d598b6a3faf7f02b6e81fb"
    sha256 catalina:       "666f827a6a686e6d2e81dc1d0eb5aae8374f01d7d1524ef6c695e3bf207c4af5"
    sha256 mojave:         "fb94b2d8e763469a2b0112523f89496f4a81e22ed9b7290f4280178f726853da"
    sha256 high_sierra:    "6cc11bcddd969e9aeb7e83692e9714d5891f0530bacbc1c52b019b298bce3d24"
    sha256 x86_64_linux:   "e0c5e8d4fd1804af9afc4425698ea01cc5a9a18303185eb7d19cdbe2b96546a7"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "docbook2x" => :build
  depends_on "libtool" => :build
  depends_on "libarchive"
  depends_on "lzo"
  depends_on "zstd"

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "llvm" => :test
    depends_on "libcap-ng"
  end

  def install
    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --enable-clang-wrappers
    ]

    system "./autogen.sh"
    system "./configure", *args
    system "make", "install"

    # Manually install scheduler property list
    (prefix/"#{plist_name}-scheduler.plist").write scheduler_plist
  end

  def caveats
    <<~EOS
      To override the toolset with icecc, add to your path:
        #{opt_libexec}/icecc/bin
    EOS
  end

  plist_options manual: "iceccd"

  def plist
    <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
      <dict>
          <key>Label</key>
          <string>#{plist_name}</string>
          <key>ProgramArguments</key>
          <array>
          <string>#{sbin}/iceccd</string>
          </array>
          <key>RunAtLoad</key>
          <true/>
      </dict>
      </plist>
    EOS
  end

  def scheduler_plist
    <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
      <dict>
          <key>Label</key>
          <string>#{plist_name}-scheduler</string>
          <key>ProgramArguments</key>
          <array>
          <string>#{sbin}/icecc-scheduler</string>
          </array>
          <key>RunAtLoad</key>
          <true/>
      </dict>
      </plist>
    EOS
  end

  test do
    (testpath/"hello-c.c").write <<~EOS
      #include <stdio.h>
      int main()
      {
        puts("Hello, world!");
        return 0;
      }
    EOS
    system opt_libexec/"icecc/bin/gcc", "-o", "hello-c", "hello-c.c"
    assert_equal "Hello, world!\n", shell_output("./hello-c")

    (testpath/"hello-cc.cc").write <<~EOS
      #include <iostream>
      int main()
      {
        std::cout << "Hello, world!" << std::endl;
        return 0;
      }
    EOS
    system opt_libexec/"icecc/bin/g++", "-o", "hello-cc", "hello-cc.cc"
    assert_equal "Hello, world!\n", shell_output("./hello-cc")

    (testpath/"hello-clang.c").write <<~EOS
      #include <stdio.h>
      int main()
      {
        puts("Hello, world!");
        return 0;
      }
    EOS
    system opt_libexec/"icecc/bin/clang", "-o", "hello-clang", "hello-clang.c"
    assert_equal "Hello, world!\n", shell_output("./hello-clang")

    (testpath/"hello-cclang.cc").write <<~EOS
      #include <iostream>
      int main()
      {
        std::cout << "Hello, world!" << std::endl;
        return 0;
      }
    EOS
    system opt_libexec/"icecc/bin/clang++", "-o", "hello-cclang", "hello-cclang.cc"
    assert_equal "Hello, world!\n", shell_output("./hello-cclang")
  end
end
