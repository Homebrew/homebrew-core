class PamU2f < Formula
  desc "Provides an easy way to use U2F-compliant authenticators with PAM"
  homepage "https://developers.yubico.com/pam-u2f/"
  url "https://developers.yubico.com/pam-u2f/Releases/pam_u2f-1.2.1.tar.gz"
  sha256 "70e741bca197b64b4fbe8dd1f6d57ce2b8ad58ca786352c525f3f2d44125894c"
  license "BSD-2-Clause"
  head "https://github.com/Yubico/pam-u2f.git", branch: "master"

  livecheck do
    url "https://developers.yubico.com/pam-u2f/Releases/"
    regex(/href=.*?pam_u2f[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "ee8921fe93e33d06b9dfd71f1f2d65f12c53026a0784cd04742721ab4e2d1fb7"
    sha256 cellar: :any,                 arm64_big_sur:  "2822396474f7aa232f60fd631d4edd20b9f4f979372f7a805444f18ae52d9d91"
    sha256 cellar: :any,                 monterey:       "d4446483af7b5fd68913eddf05a2e33ae180e093f21a6f10cc928dbca61946a0"
    sha256 cellar: :any,                 big_sur:        "8546d886dc1a3f557f7f060283744f73ea2c612e8c679f80c1e2c18101362c50"
    sha256 cellar: :any,                 catalina:       "91658eae28a984bdce370a23439e7d85896647f161a9e6f27aa9b0895e438fd6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cef93a6c6847fade402a4925e287b534848b193ae196f4571587ee2d3badbfeb"
  end

  depends_on "asciidoc" => :build
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "libfido2"

  on_linux do
    depends_on "linux-pam"
  end

  def install
    system "autoreconf", "--install"

    ENV["A2X"] = "#{Formula["asciidoc"].opt_bin}/a2x --no-xmllint"
    system "./configure", "--prefix=#{prefix}", "--with-pam-dir=#{lib}/pam"
    system "make", "install"
  end

  def caveats
    <<~EOS
      To use a U2F key for PAM authentication, specify the full path to the
      module (#{opt_lib}/pam/pam_u2f.so) in a PAM
      configuration. You can find all PAM configurations in /etc/pam.d.

      For further installation instructions, please visit
      https://developers.yubico.com/pam-u2f/#installation.
    EOS
  end

  test do
    system "#{bin}/pamu2fcfg", "--version"
  end
end
