class Mupdf < Formula
  desc "Lightweight PDF and XPS viewer"
  homepage "https://mupdf.com/"
  url "https://mupdf.com/downloads/mupdf-1.12.0-source.tar.gz"
  sha256 "5c6353a82f1512f4f5280cf69a3725d1adac9c8b22377ec2a447c4fc45528755"
  head "https://git.ghostscript.com/mupdf.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "782e1857ac9932d52ed2b1edda6cf5e8026de64e6a98df4e5aa87a0756b86e1d" => :high_sierra
    sha256 "8e2ca19930eb13fd87ea98c61f6759b8249bc4091c7dfc6a36b8ace1cd3756d3" => :sierra
    sha256 "0ba3cb19014c9233bfc91f2c67e21e588d0def1b6821f93ce7575d8129a58008" => :el_capitan
  end

  depends_on :x11
  depends_on "openssl"

  conflicts_with "mupdf-tools",
    :because => "mupdf and mupdf-tools install the same binaries."

  def install
    system "make", "install",
           "build=release",
           "verbose=yes",
           "CC=#{ENV.cc}",
           "prefix=#{prefix}",
           "HAVE_GLFW=no" # Do not build OpenGL viewer: https://bugs.ghostscript.com/show_bug.cgi?id=697842
    bin.install_symlink "mutool" => "mudraw"
  end

  test do
    assert_match "Homebrew test", shell_output("#{bin}/mudraw -F txt #{test_fixtures("test.pdf")}")
  end
end
