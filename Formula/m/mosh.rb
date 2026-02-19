class Mosh < Formula
  desc "Remote terminal application"
  homepage "https://mosh.org"
  url "https://github.com/mobile-shell/mosh/releases/download/mosh-1.4.0/mosh-1.4.0.tar.gz"
  sha256 "872e4b134e5df29c8933dff12350785054d2fd2839b5ae6b5587b14db1465ddd"
  license "GPL-3.0-or-later"
  revision 36

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "0fe164cae9fd64589583178509a1fd4cee81a4e9883992484128c6eefbaea27e"
    sha256 cellar: :any,                 arm64_sequoia: "cb0eac777d8f4203bd5ad1ecd12ff3a2a3f6f4499c215d176c305264a9475ea7"
    sha256 cellar: :any,                 arm64_sonoma:  "90c35dbd143bf8031bcd5e1a42bf0a5066da1000aed64a7b6bd5dffd6b68cecf"
    sha256 cellar: :any,                 sonoma:        "5fec87acdb8ddeca30d85d44f6b34215a73dfd5ec3f72c42ba56f1f67c2d217f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5d46d34a6367ca60ad78dae4d94ccf8e2def22fcdde49cb8890adedbe88bd2b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9c7d77a0268441bca9fccddf7c4a9ad1480dc0eb334a94c95814a4fc00a525e1"
  end

  head do
    url "https://github.com/mobile-shell/mosh.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "pkgconf" => :build
  depends_on "protobuf"

  uses_from_macos "ncurses"

  on_macos do
    depends_on "tmux" => :build # for `make check`
  end

  on_linux do
    depends_on "openssl@3" # Uses CommonCrypto on macOS
    depends_on "zlib-ng-compat"
  end

  def install
    # https://github.com/protocolbuffers/protobuf/issues/9947
    ENV.append_to_cflags "-DNDEBUG"
    # Avoid over-linkage to `abseil`.
    ENV.append "LDFLAGS", "-Wl,-dead_strip_dylibs" if OS.mac?

    # teach mosh to locate mosh-client without referring
    # PATH to support launching outside shell e.g. via launcher
    inreplace "scripts/mosh.pl", "'mosh-client", "'#{bin}/mosh-client"

    if build.head?
      # Prevent mosh from reporting `-dirty` in the version string.
      inreplace "Makefile.am", "--dirty", "--dirty=-Homebrew"
      system "./autogen.sh"
    elsif version <= "1.4.0" # remove `elsif` block and `else` at version bump.
      # Keep C++ standard in sync with abseil.rb.
      # Use `gnu++17` since Mosh allows use of GNU extensions (-std=gnu++11).
      ENV.append "CXXFLAGS", "-std=gnu++17"
    else # Remove `else` block at version bump.
      odie "Install method needs updating!"
    end

    # `configure` does not recognise `--disable-debug` in `std_configure_args`.
    system "./configure", "--prefix=#{prefix}", "--enable-completion", "--disable-silent-rules"
    system "make", "install"
  end

  test do
    system bin/"mosh-client", "-c"
  end
end
