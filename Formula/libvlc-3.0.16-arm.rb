# Documentation: https://docs.brew.sh/Formula-Cookbook
#                https://rubydoc.brew.sh/Formula
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!
class Libvlc3016Arm < Formula
  desc "multimedia player and streamer library"
  homepage "https://www.videolan.org/"
  url "https://mirror.clarkson.edu/videolan/vlc/3.0.16/macosx/vlc-3.0.16-arm64.dmg"
  sha256 "a765306f3d5cae095fa55d7ea36995e9c60939445b21a2ea44057b083da6c6e1"
  license "LGPL-2.1-or-later"

  # depends_on "libc6"
  depends_on "p7zip" => :build

  def install
    # ENV.deparallelize  # if your formula fails when building in parallel
    # Remove unrecognized options if warned by configure
    # https://rubydoc.brew.sh/Formula.html#std_configure_args-instance_method
    # system "./configure", *std_configure_args, "--disable-silent-rules"
    # system "./configure"
    # system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    include.mkpath
    lib.mkpath
    # mkdir_p "plugins"
    

    include.install "Contents/MacOS/include/vlc"

    lib.install "Contents/MacOS/lib/libvlc.5.dylib"
    lib.install "Contents/MacOS/lib/libvlc.dylib"
    lib.install "Contents/MacOS/lib/libvlccore.9.dylib"
    lib.install "Contents/MacOS/lib/libvlccore.dylib"
    mv File.join(buildpath,"/Contents/MacOS/plugins"), File.join(prefix,"/plugins")
  end

  test do
    # `test do` will create, run in and delete a temporary directory.
    #
    # This test will fail and we won't accept that! For Homebrew/homebrew-core
    # this will need to be a test that verifies the functionality of the
    # software. Run the test with `brew test vlc-3.0.16-arm`. Options passed
    # to `brew install` such as `--HEAD` also need to be provided to `brew test`.
    #
    # The installed folder is not in the path, so use the entire path to any
    # executables being tested: `system "#{bin}/program", "do", "something"`.
    system "false"
  end
end
