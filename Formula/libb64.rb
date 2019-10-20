class Libb64 < Formula
  desc "Base64 encoding/decoding library"
  homepage "https://libb64.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/libb64/libb64/libb64/libb64-1.2.src.zip"
  sha256 "343d8d61c5cbe3d3407394f16a5390c06f8ff907bd8d614c16546310b689bfd3"

  def install
    system "make"
    bin.mkpath
    bin.install "base64/base64"
    include.mkpath
    include.install "include/b64"
    lib.mkpath
    lib.install "src/libb64.a"
  end

  test do
    # `test do` will create, run in and delete a temporary directory.
    #
    # This test will fail and we won't accept that! It's enough to just replace
    # "false" with the main program this formula installs, but it'd be nice if you
    # were more thorough. Run the test with `brew test libb64`. Options passed
    # to `brew install` such as `--HEAD` also need to be provided to `brew test`.
    #
    # The installed folder is not in the path, so use the entire path to any
    # executables being tested: `system "#{bin}/program", "do", "something"`.
    system "#{bin}/base64", "-e", "/dev/null", "/dev/null"
  end
end
