class PamU2f < Formula
  desc "Provides an easy way to use U2F-compliant authenticators with PAM"
  homepage "https://developers.yubico.com/pam-u2f/"
  url "https://developers.yubico.com/pam-u2f/Releases/pam_u2f-1.4.0.tar.gz"
  sha256 "a59927cea38ea8d91a6836a04e20fc629edde4204b16082f703f6db378e9c634"
  license "BSD-2-Clause"
  head "https://github.com/Yubico/pam-u2f.git", branch: "master"

  livecheck do
    url "https://developers.yubico.com/pam-u2f/Releases/"
    regex(/href=.*?pam_u2f[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9844179a60b558f985873acb95a1b19b5fe2f3f130d5a06a4e833259c010ecc2"
    sha256 cellar: :any,                 arm64_sequoia: "f2e4356b647818a3971dc3e4feb311dd547284426717d6d4235e838b0de316c5"
    sha256 cellar: :any,                 arm64_sonoma:  "0089a1832f65debf7c4aef93e31f24f1dde60c673f888c2e6f37937e76abd23b"
    sha256 cellar: :any,                 arm64_ventura: "dc7e13adf558fab082311b0fbb128332cafa81510059db8b23aa903ed005d76f"
    sha256 cellar: :any,                 sonoma:        "59e4b1a99b4c51f5b56de184d414bd006811d83a2d032a535407e8af00fd87a4"
    sha256 cellar: :any,                 ventura:       "30a9288a77afa266fc9fa008422e9628ebd8da77c06315d317101c9c143cdc72"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f1f8f8bb7c149900e9e59fe25f24cb11ae669651a08188a801cce00cd30cd347"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a99993171f6fd57e574bf1abff0848e80aae095be2ea85e0ec766ccb5496b419"
  end

  depends_on "asciidoc" => :build
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "libfido2"
  depends_on "openssl@3"

  on_linux do
    depends_on "linux-pam"
  end

  def install
    system "autoreconf", "--force", "--install", "--verbose"

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
    system bin/"pamu2fcfg", "--version"
  end
end
