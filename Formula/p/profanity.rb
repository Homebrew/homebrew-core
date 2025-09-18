class Profanity < Formula
  desc "Console based XMPP client"
  homepage "https://profanity-im.github.io"
  url "https://profanity-im.github.io/tarballs/profanity-0.15.1.tar.gz"
  sha256 "c1e28a849aa178fd1ec5f384b0f8bdd244bce453dc4ef7bb76d0830382fec304"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_tahoe:   "a7cc2b3e861cb3d12a02341c8f874b40d43098f4643ea0c3436c300c60412f54"
    sha256 arm64_sequoia: "df081e8fe94ff007d6b4bd3a1f8843de1756c62be4173da534dbc6420ae89f38"
    sha256 arm64_sonoma:  "801eb3f994c2fd9b9ec8345e2f34cb22ae10b8a0a9634e5a05425610d26a41ab"
    sha256 arm64_ventura: "e777d8e4d9eaa49db36f165b31fb4472e06bb3bd820f505ddce25e0549ed2488"
    sha256 sonoma:        "9754d8ff9eaf93428ce7b5ee3324c1e724859c152c8fb810ce059167601d3468"
    sha256 ventura:       "3a370dc3e765d5b4aae9994472ebf502fc1409356388a16e803352ae997c92cd"
    sha256 arm64_linux:   "ad5ed73c5aea238ec66eea66552c4bbd14b2381c9a6d21f54880f469ebd993bf"
    sha256 x86_64_linux:  "96bbdc1bd7b27e3e6b42e8e2e964b799ff20b5d2d7c520ef7f6d48aa97832bef"
  end

  head do
    url "https://github.com/profanity-im/profanity.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "autoconf-archive" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "libomemo-c" => :build
  depends_on "pkgconf" => :build

  depends_on "curl"
  depends_on "glib"
  depends_on "gnutls"
  depends_on "gpgme"
  depends_on "libgcrypt"
  depends_on "libotr"
  depends_on "libstrophe"
  depends_on "python@3.13"
  depends_on "readline"
  depends_on "sqlite"

  uses_from_macos "ncurses"

  on_macos do
    depends_on "gettext"
    depends_on "libassuan"
    depends_on "libgpg-error"
    depends_on "terminal-notifier"
  end

  def install
    ENV.prepend_path "PATH", Formula["python@3.13"].opt_libexec/"bin"

    system "./bootstrap.sh" if build.head?

    # We need to pass `BREW` to `configure` to make sure it can be found inside the sandbox in non-default
    # prefixes. `configure` knows to check `/opt/homebrew` and `/usr/local`, but the sanitised build
    # environment will prevent any other `brew` installations from being found.
    system "./configure", "--disable-silent-rules",
                          "--enable-python-plugins",
                          "BREW=#{HOMEBREW_BREW_FILE}",
                          *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"profanity", "-v"
  end
end
