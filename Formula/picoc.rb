class Picoc < Formula
  desc "C interpreter for scripting"
  homepage "https://github.com/zsaleeba/picoc"
  url "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/picoc/picoc-2.1.tar.bz2"
  sha256 "bfed355fab810b337ccfa9e3215679d0b9886c00d9cb5e691f7e7363fd388b7e"

  bottle do
    cellar :any_skip_relocation
    sha256 "8677b5fe46a67991ed8bbec9d9727472a866d77e23f159124bb833dfc98f4f28" => :sierra
    sha256 "8c9bff2043ec4140a347e048741caed8c9f286f3958af1bd0e4fdb5c8817ae43" => :el_capitan
    sha256 "05b84e43b6dc919361a4dc3763350bd471ff793c2aaddcd8696fe708be1dad10" => :yosemite
    sha256 "19a25b578aaf48405e46341158dc62379a66fca36f7363d01bfcab4c0cea5209" => :mavericks
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
