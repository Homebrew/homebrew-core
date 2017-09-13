class Picoc < Formula
  desc "C interpreter for scripting"
  homepage "https://github.com/zsaleeba/picoc"
  revision 1
  head "https://github.com/zsaleeba/picoc.git"

  stable do
    url "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/picoc/picoc-2.1.tar.bz2"
    mirror "https://dl.bintray.com/homebrew/mirror/picoc-2.1.tar.bz2"
    sha256 "bfed355fab810b337ccfa9e3215679d0b9886c00d9cb5e691f7e7363fd388b7e"

    # Remove for > 2.1
    # Fix abort trap due to stack overflow
    # Upstream commit from 14 Oct 2013 "Fixed a problem with PlatformGetLine()"
    patch do
      url "https://github.com/zsaleeba/picoc/commit/ed54c51.patch?full_index=1"
      sha256 "2111ad8d038cf0063430746bf868b56f4658e79b87e4b94b03d00fb58af8564f"
    end
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "456707c08da75cf7ad3f98898dda357617b5295c4a09631366e06f9bdb1e09f4" => :sierra
    sha256 "abd8328d9db2961516c421b09d0da77f7df9c09314d2d09530af27a0fe2d55d7" => :el_capitan
    sha256 "5d732cb34ea6a0349f82bf39f948ab9b49be72273a264c52d0a0773ade2acba1" => :yosemite
  end

  def install
    system "make", "CC=#{ENV.cc}", "CFLAGS=#{ENV.cflags} -DUNIX_HOST"
    bin.install "picoc"
  end

  test do
    (testpath/"brew.c").write <<-EOS.undent
      #include <stdio.h>
      int main(void) {
        printf("Homebrew\n");
        return 0;
      }
    EOS
    assert_match "Homebrew", shell_output("#{bin}/picoc brew.c")
  end
end
