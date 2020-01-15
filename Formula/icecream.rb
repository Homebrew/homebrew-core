class Icecream < Formula
  desc "Distributed compiler with a central scheduler to share build load"
  homepage "https://en.opensuse.org/Icecream"
  url "https://github.com/icecc/icecream/archive/1.3.tar.gz"
  sha256 "5e147544dcc557ae6f0b13246aa1445f0f244f010de8e137053078275613bd00"
  revision 1

  bottle do
    sha256 "4695f1db7d16476613f6778408167c67a8e22adb9a5506a4eab61b84e3105ad9" => :catalina
    sha256 "e462d0c5ce28511fdf6186dcbcc292462fb3084c97831d07a6b430c1306fd946" => :mojave
    sha256 "b7799dfc83e7cca7616eaa82afea0218f6c733b609e6a8850e111b1c62426f27" => :high_sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "docbook2x" => :build
  depends_on "libtool" => :build
  depends_on "libarchive"
  depends_on "lzo"
  depends_on "zstd"

  # Backport https://github.com/icecc/icecream/pull/511
  # icecc-create-env was broken on darwin. Remove in next stable release
  patch do
    url "https://github.com/icecc/icecream/commit/10b9468f5bd30a0fdb058901e91e7a29f1bfbd42.patch?full_index=1"
    sha256 "dcf817be4549b2a732935e5bb6e310c135324929578a59ec3e55514b2b580360"
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

  def caveats; <<~EOS
    To override the toolset with icecc, add to your path:
      #{opt_libexec}/icecc/bin
  EOS
  end

  plist_options :manual => "iceccd"

  def plist; <<~EOS
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

  def scheduler_plist; <<~EOS
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
