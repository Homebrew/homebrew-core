# "File" is a reserved class name
class FileFormula < Formula
  desc "Utility to determine file types"
  homepage "https://darwinsys.com/file/"
  url "https://astron.com/pub/file/file-5.48.tar.gz"
  sha256 "ed14656883b23a364b4057c05595d93252da9bc473d30106519519d0da141283"
  license "BSD-2-Clause-Darwin"
  head "https://github.com/file/file.git", branch: "master"

  livecheck do
    url "https://astron.com/pub/file/"
    regex(/href=.*?file[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "20a86cf7e73bf15221d571d5ccb0c27d7a4dbdbb1b0dd442cf335f3010db6735"
    sha256 cellar: :any, arm64_sequoia: "b63a49e329af2af9c2f587b5f1ce1a2ee11306328debb50f2a06dfc7d1158668"
    sha256 cellar: :any, arm64_sonoma:  "7721c56b96dba8e3a8c1e03bd48b8481362c46b14e9583a124882077a075846c"
    sha256 cellar: :any, sonoma:        "c41ae633056c3a2a3994ce3c5490848966687f3018ceb86a0edec6005e55de39"
    sha256 cellar: :any, arm64_linux:   "28737ef77e9a3aeac34605aa8babc7413ac91e8b67f6c73386caefec16e7f4c8"
    sha256 cellar: :any, x86_64_linux:  "30457786f6ab679e297d69f774fbfd97b545bc0401d569d27274ecb3c8f90bae"
  end

  keg_only :provided_by_macos

  depends_on "libmagic"

  def install
    ENV.prepend "LDFLAGS", "-L#{formula_opt_lib("libmagic")} -lmagic"

    system "./configure", *std_configure_args
    system "make", "install-exec", "file_DEPENDENCIES=", "file_LDADD=$(LDADD) -lm"
    system "make", "-C", "doc", "install-man1"
    rm_r lib
  end

  test do
    system bin/"file", test_fixtures("test.mp3")
  end
end
