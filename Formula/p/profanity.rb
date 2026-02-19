class Profanity < Formula
  desc "Console based XMPP client"
  homepage "https://profanity-im.github.io"
  url "https://profanity-im.github.io/tarballs/profanity-0.15.1.tar.gz"
  sha256 "c1e28a849aa178fd1ec5f384b0f8bdd244bce453dc4ef7bb76d0830382fec304"
  license "GPL-3.0-or-later"

  bottle do
    rebuild 2
    sha256 arm64_tahoe:   "07913342ee22f369f347e9f67e28f13e568d0cac0124c37176cc6ad023e4e9df"
    sha256 arm64_sequoia: "bc619cfe669ca728e70997889751e4637fb935f81e500d1a06214e7219d4ac75"
    sha256 arm64_sonoma:  "338a44b6ca1db72543de3f99563fc04eef1339e17c79d6cf48be674cc6bf9c91"
    sha256 sonoma:        "219c10327d821c4a29ca7d9dd017065a014f19172242527c420d1072ae4ef66a"
    sha256 arm64_linux:   "43c24f4c416b203d3a2bbc23d0283dd9bcd5d2ef8b1a981295074d6d08c5a10f"
    sha256 x86_64_linux:  "5176b82971277b3eefa45c717de284494b2a1bda083a584a5c69141fb238bf35"
  end

  head do
    url "https://github.com/profanity-im/profanity.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "autoconf-archive" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkgconf" => :build

  depends_on "glib"
  depends_on "gpgme"
  depends_on "libotr"
  depends_on "libstrophe"
  depends_on "python@3.14"
  depends_on "readline"
  depends_on "sqlite"

  uses_from_macos "curl"
  uses_from_macos "ncurses"

  on_macos do
    depends_on "gettext"
    depends_on "libassuan"
    depends_on "libgpg-error"
    depends_on "terminal-notifier"
  end

  def install
    ENV.prepend_path "PATH", Formula["python@3.14"].opt_libexec/"bin"

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
