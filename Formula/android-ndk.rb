class AndroidNdk < Formula
  desc "Android native-code language toolset"
  homepage "https://developer.android.com/ndk/index.html"
  url "https://dl.google.com/android/repository/android-ndk-r12-darwin-x86_64.zip"
  version "r12"
  sha256 "fe10b64a65f3e818b852862975ea7b5896295cd1301d1acdbeb1294d9592fb19"

  bottle :unneeded

  # As of r10e, only a 64-bit version is provided
  depends_on :arch => :x86_64
  depends_on "android-sdk" => :recommended

  conflicts_with "crystax-ndk",
    :because => "both install `ndk-build`, `ndk-gdb` and `ndk-stack` binaries"

  def install
    bin.mkpath

    # Now we can install both 64-bit and 32-bit targeting toolchains
    prefix.install Dir["*"]

    # Create a dummy script to launch the ndk apps
    ndk_exec = prefix+"ndk-exec.sh"
    ndk_exec.write <<-EOS.undent
      #!/bin/sh
      BASENAME=`basename $0`
      EXEC="#{prefix}/$BASENAME"
      test -f "$EXEC" && exec "$EXEC" "$@"
    EOS
    ndk_exec.chmod 0755
    %w[ndk-build ndk-depends ndk-gdb ndk-stack ndk-which].each { |app| bin.install_symlink ndk_exec => app }
  end

  def caveats; <<-EOS.undent
    We agreed to the Android NDK License Agreement for you by downloading the NDK.
    If this is unacceptable you should uninstall.

    License information at:
    https://developer.android.com/sdk/terms.html

    Software and System requirements at:
    https://developer.android.com/sdk/ndk/index.html#requirements

    For more documentation on Android NDK, please check:
      #{prefix}/docs
    EOS
  end
end
