class Picoc < Formula
  desc "C interpreter for scripting"
  homepage "https://gitlab.com/zsaleeba/picoc"
  license "BSD-3-Clause"
  revision 1
  head "https://gitlab.com/zsaleeba/picoc.git"

  stable do
    url "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/picoc/picoc-2.1.tar.bz2"
    mirror "https://dl.bintray.com/homebrew/mirror/picoc-2.1.tar.bz2"
    sha256 "bfed355fab810b337ccfa9e3215679d0b9886c00d9cb5e691f7e7363fd388b7e"

    # Remove for > 2.1
    # Fix abort trap due to stack overflow
    # Upstream commit from 14 Oct 2013 "Fixed a problem with PlatformGetLine()"
    patch do
      url "https://gitlab.com/zsaleeba/picoc/commit/ed54c519169b88b7b40d1ebb11599d89a4228a71.patch"
      sha256 "bdedbb6e70e6378e05e50d0ef055306045e460f2675f8bd870566ae28b654589"
    end
  end

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "41d9836d62b70b7fe1117f4697417d9a03615639f2ff1390f0f1d21003426bb1" => :big_sur
    sha256 "b39c116bb09cdd9f91143aaf9c928feadac8b281807e06ab87c4ca2992c13ec4" => :arm64_big_sur
    sha256 "168aebca830b719b3645b682c9c3f1208663b6853b62d68ddeb2957ee6c8bc07" => :catalina
    sha256 "0251ecfb5772bffbb92457af974af44856d25215d1d9bd692530b6b53517f71a" => :mojave
    sha256 "5b2c6a5c8c3404cbd75b4b0e1c6f6cbf1be0246ca0b3d1df70d78a6785e51711" => :high_sierra
  end

  def install
    system "make", "CC=#{ENV.cc}", "CFLAGS=#{ENV.cflags} -DUNIX_HOST"
    bin.install "picoc"
  end

  test do
    (testpath/"brew.c").write <<~EOS
      #include <stdio.h>
      int main(void) {
        printf("Homebrew\n");
        return 0;
      }
    EOS
    assert_match "Homebrew", shell_output("#{bin}/picoc brew.c")
  end
end
