class Icecream < Formula
  desc "Distributed compiler with a central scheduler to share build load"
  homepage "https://en.opensuse.org/Icecream"
  url "https://github.com/icecc/icecream/archive/refs/tags/1.4.tar.gz"
  sha256 "249dcf74f0fc477ff9735ff0bdcdfaa4c257a864c4db5255d8b25c9f4fd20b6b"
  license "GPL-2.0-or-later"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 arm64_tahoe:    "13a9005297bac5939d73c7cb06837620691588609ff902db613ed9bbb12cd139"
    sha256 arm64_sequoia:  "3e72ef8ca299726695641f68412f9071e3840671808710ae1d4fc09b120d73e8"
    sha256 arm64_sonoma:   "cd4ee875fc4006985db7d2caab6039e97ea091165f1c683e19dd104e54362890"
    sha256 arm64_ventura:  "95f69b28c10fbe5af6475f27d70bf86279839de46ef27c3ea08e76b8fa97772d"
    sha256 arm64_monterey: "053f5583b18d4201020f59f9d4481a2d6c0b584c5bb3297038ddd9653d70998e"
    sha256 arm64_big_sur:  "1a26f6bb194f5e27212c555783574c81d56f4fcb5e3bdc410278f8f74b128016"
    sha256 sonoma:         "52b41894ec8d21e972bdbe27965b0c3113870a50f7d9a334e8bfb8a244585087"
    sha256 ventura:        "2b6b3e86015280b1ab00f8ced1ce1dad32800c316627d7cba4165931f44a58fc"
    sha256 monterey:       "781ad1cb41ba91d5bd7b2f6763807b3fd89a0ff30b572b8ec77273d713867c1e"
    sha256 big_sur:        "076868e850f3b6b5ae814e19b03528143ea5bb3f903edcdca14cac7ce3fbf4e8"
    sha256 catalina:       "a85e725c50fc4fad0d28621cd9c241326c516b3bfb32e01a4710615b0bcec4f5"
    sha256 arm64_linux:    "de2b7ebbe426439abbbeb9a93d329d802b7ac1c58cabe4fa47e9954ec0332ecd"
    sha256 x86_64_linux:   "9eef6bec6b3f10bb768c84872285e4ffe45e45ffcd4e05c4e7727c702875d044"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "docbook2x" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "libarchive"
  depends_on "lzo"
  depends_on "zstd"

  on_linux do
    depends_on "llvm" => :test
    depends_on "libcap-ng"
  end

  def install
    args = %w[
      --disable-silent-rules
      --enable-clang-wrappers
    ]

    system "./autogen.sh"
    system "./configure", *args, *std_configure_args
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

  service do
    run opt_sbin/"iceccd"
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
    (testpath/"hello-c.c").write <<~C
      #include <stdio.h>
      int main()
      {
        puts("Hello, world!");
        return 0;
      }
    C
    system opt_libexec/"icecc/bin/gcc", "-o", "hello-c", "hello-c.c"
    assert_equal "Hello, world!\n", shell_output("./hello-c")

    (testpath/"hello-cc.cc").write <<~CPP
      #include <iostream>
      int main()
      {
        std::cout << "Hello, world!" << std::endl;
        return 0;
      }
    CPP
    system opt_libexec/"icecc/bin/g++", "-o", "hello-cc", "hello-cc.cc"
    assert_equal "Hello, world!\n", shell_output("./hello-cc")

    (testpath/"hello-clang.c").write <<~C
      #include <stdio.h>
      int main()
      {
        puts("Hello, world!");
        return 0;
      }
    C
    system opt_libexec/"icecc/bin/clang", "-o", "hello-clang", "hello-clang.c"
    assert_equal "Hello, world!\n", shell_output("./hello-clang")

    (testpath/"hello-cclang.cc").write <<~CPP
      #include <iostream>
      int main()
      {
        std::cout << "Hello, world!" << std::endl;
        return 0;
      }
    CPP
    system opt_libexec/"icecc/bin/clang++", "-o", "hello-cclang", "hello-cclang.cc"
    assert_equal "Hello, world!\n", shell_output("./hello-cclang")
  end
end
