class Icecream < Formula
  desc "Distributed compiler with a central scheduler to share build load"
  homepage "https://en.opensuse.org/Icecream"
  url "https://github.com/icecc/icecream/archive/1.1.tar.gz"
  sha256 "92532791221d7ec041b7c5cf9998d9c3ee8f57cbd2da1819c203a4c6799ffc18"

  bottle do
    sha256 "ac7f6745981bd1c0853af12c4a460cd196a95b7c27c6072746db62086e6afcf0" => :high_sierra
    sha256 "ff931dd74efc02cad494df41e2df0919fd1a65b2908ade15566b5a6f0974e3ee" => :sierra
    sha256 "744922ad03cb2468d1b3251238f7130fb1e4295388370bf47d6edeb43a8c36b2" => :el_capitan
    sha256 "0adc60662ea9ede33caf1fffb35a129593479a99c34bb36525c1c718b0a77639" => :yosemite
  end

  option "with-docbook2X", "Build with man page"
  option "without-clang-wrappers", "Don't use symlink wrappers for clang/clang++"
  option "with-clang-rewrite-includes", "Use by default Clang's -frewrite-includes option"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "lzo"
  depends_on "docbook2x" => [:optional, :build]

  def install
    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
    ]
    args << "--without-man" if build.without? "docbook2X"
    args << "--enable-clang-wrappers" if build.with? "clang-wrappers"
    args << "--enable-clang-write-includes" if build.with? "clang-rewrite-includes"

    system "./autogen.sh"
    system "./configure", *args
    system "make", "install"

    (prefix/"org.opensuse.icecc.plist").write iceccd_plist
    (prefix/"org.opensuse.icecc-scheduler.plist").write scheduler_plist
  end

  def caveats; <<~EOS
    To override the toolset with icecc, add to your path:
      #{opt_libexec}/icecc/bin

    To have launchd start the icecc daemon at login:
      cp #{opt_prefix}/org.opensuse.icecc.plist ~/Library/LaunchAgents/
      launchctl load -w ~/Library/LaunchAgents/org.opensuse.icecc.plist
    EOS
  end

  def iceccd_plist; <<~EOS
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
        <key>Label</key>
        <string>Icecc Daemon</string>
        <key>ProgramArguments</key>
        <array>
        <string>#{sbin}/iceccd</string>
        <string>-d</string>
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
        <string>Icecc Scheduler</string>
        <key>ProgramArguments</key>
        <array>
        <string>#{sbin}/icecc-scheduler</string>
        <string>-d</string>
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

    if build.with? "clang-wrappers"
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
end
