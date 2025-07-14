class Mosh < Formula
  desc "Remote terminal application"
  homepage "https://mosh.org"
  url "https://github.com/mobile-shell/mosh/releases/download/mosh-1.4.0/mosh-1.4.0.tar.gz"
  sha256 "872e4b134e5df29c8933dff12350785054d2fd2839b5ae6b5587b14db1465ddd"
  license "GPL-3.0-or-later"
  revision 28

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "755a860faf4f4eb8715bb132abc76a8569b1b266c610fbd7ac4b7fe1ab48a539"
    sha256 cellar: :any,                 arm64_sonoma:  "1410eac2e92eadf9dcc717f3d4d80d0505b8a32799d40831f6af95f9e0622df4"
    sha256 cellar: :any,                 arm64_ventura: "3ee966425def3198861ce28cda95106a572b1a9ee9a0fe4b1e7e7fc673f7b6a9"
    sha256 cellar: :any,                 sonoma:        "9d195badfc9d371c8e3f7e53606a1c8a35d2b28539013927632dae8c7c4619fa"
    sha256 cellar: :any,                 ventura:       "83cfdc9ce4e3e5dd72284c4525272217e57cde54b11d6c6043bde2fc62ff63c9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2a8a37afa1b8ae7a1f5b3a48859e33f7b93a7529e53780dd50231668bd088fea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a4fe1a8fc42c1ae159ccb9219f2c39ce6174c24df3f1f724887f6a7bc40fb321"
  end

  head do
    url "https://github.com/mobile-shell/mosh.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "pkgconf" => :build
  depends_on "protobuf"

  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  on_macos do
    depends_on "tmux" => :build # for `make check`
  end

  on_linux do
    depends_on "openssl@3" # Uses CommonCrypto on macOS
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
