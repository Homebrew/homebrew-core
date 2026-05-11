class Hydra < Formula
  desc "Network logon cracker which supports many services"
  homepage "https://github.com/vanhauser-thc/thc-hydra"
  url "https://github.com/vanhauser-thc/thc-hydra/archive/refs/tags/v9.7.tar.gz"
  sha256 "8dbe11e5858b8c1aab7bd670bc39a3483accd09e147d3dd981fe11a7fa0d10de"
  license "AGPL-3.0-only"
  head "https://github.com/vanhauser-thc/thc-hydra.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "1da116ec3e9e0c199532be9dab820da943fd90882a26c4299e5784783b680af2"
    sha256 cellar: :any,                 arm64_sequoia: "59462731671d23a67a26c61731967a0997cf97be55b47241bb7bc8773315d5b7"
    sha256 cellar: :any,                 arm64_sonoma:  "1587d19830a37949d7997933c8c2e0aabaef9d13ff054e588ae2c0461fd1b15b"
    sha256 cellar: :any,                 arm64_ventura: "e9ec5262f77f8f099f7d1fcf0a4c35d8cc66f71af7dd9629f4b662dfb4bbe125"
    sha256 cellar: :any,                 sonoma:        "32ae8946b3891da2b56df93f7de828243be8498ddbca4e4a20b3864c9f052dd4"
    sha256 cellar: :any,                 ventura:       "7ce1e368623e1a98fa4594879774604d871b56eedea4127c4bdafb59369e1e8c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "564ffb41b6e522fd8a13fc3ae634aa888144c66216198a96dd81d61ee2ba6205"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e062f5c8583970cd8fff70e7f4ae8ead1b2514c8e4d0fac47422990aa21940ae"
  end

  depends_on "pkgconf" => :build
  depends_on "libssh"
  depends_on "mariadb-connector-c"
  depends_on "openssl@3"
  depends_on "pcre2"

  uses_from_macos "ncurses"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  conflicts_with "ory-hydra", because: "both install `hydra` binaries"

  # Fix configure libdirs https://github.com/vanhauser-thc/thc-hydra/pull/1077
  patch do
    url "https://github.com/vanhauser-thc/thc-hydra/commit/8ca0f6dc8ad0c950aa9bfd0315961825ced30327.patch?full_index=1"
    sha256 "4dd38b27010fc937976530febeb3762df6ffb335735d0f5a392fcf3adbf4f833"
  end

  def install
    # add homebrew library and include paths to the search path on Linux
    if OS.linux?
      ENV["LIBDIRS"] = ENV["HOMEBREW_LIBRARY_PATHS"].tr(":", " ")

      ENV["INCDIRS"] = [
        *ENV["HOMEBREW_INCLUDE_PATHS"].split(":"),
        (Formula["mariadb-connector-c"].opt_include/"mariadb").to_s,
        *ENV["HOMEBREW_ISYSTEM_PATHS"].split(":"),
      ].join(" ")
    end

    inreplace "configure" do |s|
      # Avoid opportunistic linking of everything
      %w[
        libfreerdp
        libgcrypt
        libmongoc
        libpq
        libsvn
      ].each do |lib|
        s.gsub! lib, "disabled-#{lib}"
      end
    end

    # Having our gcc in the PATH first can cause issues. Monitor this.
    # https://github.com/vanhauser-thc/thc-hydra/issues/22
    system "./configure", "--disable-xhydra", *std_configure_args
    bin.mkpath
    system "make", "all", "install"
    share.install prefix/"man" # Put man pages in correct place
  end

  test do
    output = shell_output(bin/"hydra", 255)
    assert_match "mysql", output
    assert_match "ssh", output
  end
end
