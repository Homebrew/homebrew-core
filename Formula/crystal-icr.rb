class CrystalIcr < Formula
  desc "Interactive console for Crystal programming language"
  homepage "https://github.com/crystal-community/icr"
  url "https://github.com/crystal-community/icr/archive/v0.8.0.tar.gz"
  sha256 "8c7825dd035bbb4bc6499873d4bd125185a01cae10dc8dd6f98e6e013def381c"
  license "MIT"

  bottle do
    rebuild 1
    sha256 big_sur:      "27aca5fd1d1b212b90575dd385b27cbc215aea9510cab6c24efe18ec15d617cc"
    sha256 catalina:     "a0683b8dce5fd77b89f4ba6412ad1ad7b793abfd2e703f9cff72e2ffe7248d43"
    sha256 mojave:       "30bbc4ad85339e27305d4294cf53e3ddc252f137599b7602ca2930f01728cd8c"
    sha256 x86_64_linux: "722032d357e541908a6d9899a6e77284a4cdeb312c16b3d44485cdfdd0502436"
  end

  depends_on "crystal"
  depends_on "libevent"
  depends_on "libyaml"
  depends_on "openssl@1.1"

  # Fix build: src/icr/cli.cr:69:14: Error: undefined method 'parse!' for OptionParser.class
  # Remove in the next release.
  patch do
    url "https://github.com/crystal-community/icr/commit/39d0f075aa5afd895473a223d854089de86f9230.patch?full_index=1"
    sha256 "51867797493ebd2ec681c57132ca5576cef16b0e188ce2f6cacb41b523ae04ed"
  end

  # Fix build: src/icr/executer.cr:66:13: Error: undefined method 'rmdir' for Dir.class
  # https://github.com/crystal-community/icr/commit/2a8b05b5b98a804fb0daa5be4834db4f56db0496
  # Remove in the next release.
  patch :DATA

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    assert_match "icr version #{version}", shell_output("#{bin}/icr -v")
  end
end

__END__
diff --git a/src/icr/executer.cr b/src/icr/executer.cr
index 0c1ce0b..102f28e 100644
--- a/src/icr/executer.cr
+++ b/src/icr/executer.cr
@@ -63,7 +65,7 @@ module Icr

       # Remove empty directories, including ".crystal"
       while empty_dir?(path)
-        Dir.rmdir(path)
+        Dir.delete(path)
         break if path == dot_crystal_dir
         path = File.expand_path("..", path)
       end
