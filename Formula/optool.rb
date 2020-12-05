class Optool < Formula
  desc "Command-Line tool for interacting with MachO binaries on macOS/iOS"
  homepage "https://github.com/alexzielenski/optool"
  # pull from git tag to get submodules
  url "https://github.com/alexzielenski/optool.git",
      tag:      "0.1",
      revision: "a20c514baa2018adf53a0a408b9ee72cba107155"
  license "BSD-2-Clause"
  head "https://github.com/alexzielenski/optool.git"

  depends_on xcode: :build

  def install
    xcodebuild "SDKROOT=",
               "SYMROOT=build", "OBJROOT=build", "DSTROOT=build",
               "-project", "optool.xcodeproj",
               "-target", "optool",
               "-configuration", "Release",
               "OTHER_LDFLAGS='-ObjC'"
    bin.install "build/Release/optool"
  end

  test do
    if build.stable?
      result = shell_output("#{bin}/optool 2>&1", 13)
      assert_match "optool v#{version}", result
    end

    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      int main()
      {
        printf("Hello World!\\n");
        return 0;
      }
    EOS

    # Build dynamic library fixture
    system ENV.cc, "test.c",
                   "-shared", "-Wl,-install_name,@executable_path/libtest.dylib",
                    "-o", "libtest.dylib"

    # Build MachO binary fixture
    system ENV.cc, "test.c",
                   "-o", "test"

    # Test insertion of load command for dynamic library into binary
    system "#{bin}/optool", "install",
                            "--command", "load",
                            "--payload", "@executable_path/libtest.dylib",
                            "--target", "#{testpath}/test"

    # Test removal of load command for dynamic library into binary
    system "#{bin}/optool", "uninstall",
                            "--payload", "@executable_path/libtest.dylib",
                            "--target", "#{testpath}/test"
  end
end
