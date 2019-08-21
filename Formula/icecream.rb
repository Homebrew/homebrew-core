class Icecream < Formula
  desc "Distributed compiler with a central scheduler to share build load"
  homepage "https://en.opensuse.org/Icecream"
  url "https://github.com/icecc/icecream/archive/1.2.tar.gz"
  sha256 "12d4132e5aacf6907877b691a8ac09e3e2f704ca016c49bc5eb566fc9185f544"
  revision 1

  bottle do
    sha256 "2118015d81859d3149fcc2ca0cc46f3c33962196763926296adf13eb3e8f6872" => :mojave
    sha256 "3bf33081248ecf62d9023e72e7a46601768fae1863a9c01cda22a5ca35612dd7" => :high_sierra
    sha256 "b1a775dafdaf583d71357f389c6851c397e8e56cbbca41f3d426915d74c3a1be" => :sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "docbook2x" => :build
  depends_on "libtool" => :build
  depends_on "lzo"

  # Backport https://github.com/icecc/icecream/pull/467
  # Total memory was not correctly detected on macOS, resulting in a hard limit of 100MB
  # being set. Remove in next stable release.
  patch do
    url "https://github.com/icecc/icecream/commit/1af3a23521cfd7dc1a067625f311ebc5d4f34a08.patch?full_index=1"
    sha256 "a21b05bc18dfff8e29d0d0f6f7acdfc2fcfe3a7daaf7646340bc51cf28186445"
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
