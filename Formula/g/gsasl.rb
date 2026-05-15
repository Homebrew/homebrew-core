class Gsasl < Formula
  desc "SASL library command-line interface"
  homepage "https://www.gnu.org/software/gsasl/"
  url "https://ftpmirror.gnu.org/gnu/gsasl/gsasl-2.2.3.tar.gz"
  mirror "https://ftp.gnu.org/gnu/gsasl/gsasl-2.2.3.tar.gz"
  sha256 "fee36c66ac12d32d3bf29a7b35ad8f444b7996fe369b9da5d36fd6ae649c68eb"
  license "GPL-3.0-or-later"
  compatibility_version 1

  bottle do
    sha256 arm64_tahoe:   "c6f2f819428c67bde23b7c4ab18ac89d5f37f1524dd27d4cc48e96d3305de4ae"
    sha256 arm64_sequoia: "4bfd53166cf8a715d97a621ec1df48be005f3a71a86b3a21f08514377c4e28b3"
    sha256 arm64_sonoma:  "b50afd10fccb091ff521420839a9cc137249d4b10b57140f310d86d766344703"
    sha256 sonoma:        "563601d7eb1811c0655ae6fcf81189dfccdabc650ea5a2d2bc97fae138bd90d3"
    sha256 arm64_linux:   "afa8aa7a30cc4cf206474b87a9d93a2080c29aa951a70fa129cb7ad8cd37cdaa"
    sha256 x86_64_linux:  "b4dcd4833df9890718a8ef900ac0d3191f64362c7418eae79bacfa6b1e89626a"
  end

  depends_on "libgcrypt"

  on_macos do
    depends_on "gettext"
  end

  def install
    system "./configure", "--with-gssapi-impl=mit", *std_configure_args
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gsasl --version")
  end
end
