class Mosh < Formula
  desc "Remote terminal application"
  homepage "https://mosh.org"
  url "https://github.com/mobile-shell/mosh/releases/download/mosh-1.4.0/mosh-1.4.0.tar.gz"
  sha256 "872e4b134e5df29c8933dff12350785054d2fd2839b5ae6b5587b14db1465ddd"
  license "GPL-3.0-or-later"
  revision 38

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c6c29798f55a07c404fcb9e6a8ea09941fda9d547f39852b7588ac319b3da456"
    sha256 cellar: :any,                 arm64_sequoia: "cdd1ac12f9a2feffeeed69391613b727cfa75f010f886509ef63e4b929eeb08b"
    sha256 cellar: :any,                 arm64_sonoma:  "4d3d806753e0de1128ffaa8dc28cc59a44e545c245c0f6e1d0c1dfa9cb7d0b43"
    sha256 cellar: :any,                 sonoma:        "b496ca4f94d0e55024faa7f9c7897b2ac53c6d1d527cf072089907e08a89ed33"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d9efbabcdb8f49a096181811e0a86ae9737352313209d0461db3d09d8548f93c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ff450a5a79e77fda8c435059d4bd3e1c1441fbcf30d7a973278f82a6725a8d4e"
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
