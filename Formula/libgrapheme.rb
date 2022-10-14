class Libgrapheme < Formula
  desc "Unicode string library"
  homepage "https://libs.suckless.org/libgrapheme/"
  url "https://dl.suckless.org/libgrapheme/libgrapheme-2.0.1.tar.gz"
  sha256 "3db593a20fcbedcf4aa01c2ff973c430c40e19b961422ded95efe74a216cda2a"
  license "ISC"
  head "git://git.suckless.org/libgrapheme/", branch: "master"

  def install
    args = if OS.mac?
      soflags = %w[
        -dynamiclib
        -installname 'libgrapheme.$(VERSION_MAJOR).dylib'
        -current_version '$(VERSION_MAJOR).$(VERSION_MINOR).$(VERSION_PATCH)'
        -compatibility_version '$(VERSION_MAJOR).$(VERSION_MINOR).0'
      ]

      [
        "PREFIX=#{prefix}",
        "SOFLAGS=#{soflags.join(" ")}",
        "SONAME=libgrapheme.$(VERSION_MAJOR).dylib",
        "SOSYMLINK=false",
        "LDCONFIG=",
      ]
    else
      [
        "PREFIX=#{prefix}",
        "LDCONFIG=",
      ]
    end

    system "make", *args, "install"
  end

  test do
    (testpath/"example.c").write <<~EOS
      #include <grapheme.h>

      int
      main(void)
      {
        return (grapheme_next_word_break_utf8("Hello World!", SIZE_MAX) != 5);
      }
    EOS
    system ENV.cc, "example.c", "-I#{include}", "-L#{lib}", "-lgrapheme", "-o", "example"
    system "./example"
  end
end
