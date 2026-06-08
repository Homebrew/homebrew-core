class Mosh < Formula
  desc "Remote terminal application"
  homepage "https://mosh.org"
  url "https://github.com/mobile-shell/mosh/releases/download/mosh-1.4.0/mosh-1.4.0.tar.gz"
  sha256 "872e4b134e5df29c8933dff12350785054d2fd2839b5ae6b5587b14db1465ddd"
  license "GPL-3.0-or-later"
  revision 39

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f9d043aa844c54fad11164f5a67eccb7bcefd8885d135946c86cf98f0909a8f7"
    sha256 cellar: :any,                 arm64_sequoia: "7ed888abf5bb347315892918d6c24ce0fef67038df13af65954fd62c06a9f87e"
    sha256 cellar: :any,                 arm64_sonoma:  "a0eb513111b0d2ade1c31be69a80f05cb242ce5b6d5648abe37c5c40637e1cae"
    sha256 cellar: :any,                 sonoma:        "f0226b76c05d1057f15bc28e0ec6cc8708f832d3c63cbb8a8cce93fcd439e85a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a08aa10e0a35337d91ae129c7f9e5671e6fb84b05bb220ed3c5a35c511bd0728"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5e985adb6c637914088dc4d49feeebda2686a4067f34a253764965a193eb0e1c"
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
