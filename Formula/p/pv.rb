class Pv < Formula
  desc "Monitor data's progress through a pipe"
  homepage "https://www.ivarch.com/programs/pv.shtml"
  url "https://www.ivarch.com/programs/sources/pv-1.10.2.tar.gz"
  sha256 "3f7b47f0eaf66f9c2a487fc5dbc409cd00bfe5ecd8a9b198d76f1ed39f792dc9"
  license "Artistic-2.0"

  livecheck do
    url :homepage
    regex(/href=.*?pv[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "97ef9eb50173b8d969bf575415a6c214092c8f85bbeb20563aa37bd35de9f7bb"
    sha256 arm64_sequoia: "f051c6d031da62813b1246931b470cb57e5fd49cfb064a30d83e848d11970db6"
    sha256 arm64_sonoma:  "cc8d7b9245fb9b4d61c15ba91debeb72713921f5aea1d223ab575c7f25472a6d"
    sha256 sonoma:        "11a325f73270183224a0b0cb1dccaa6f4164e5a83eb9bffffc6fe80cfb1b5c38"
    sha256 arm64_linux:   "9d071c1aebe21357412b8da935cf9a8bd2e72bd4041e916a8a611ada5c957b70"
    sha256 x86_64_linux:  "7cbf92dbed360ac1849b971c42a0663f8df4ed08c5bdee68ab082a599c718324"
  end

  uses_from_macos "ncurses"

  on_macos do
    depends_on "gettext"
  end

  def install
    # Fix compile with newer Clang
    ENV.append_to_cflags "-Wno-implicit-function-declaration" if DevelopmentTools.clang_build_version >= 1403

    system "./configure", "--mandir=#{man}", *std_configure_args
    system "make", "install"
  end

  test do
    progress = pipe_output("#{bin}/pv -ns 4 2>&1 >/dev/null", "beer")
    assert_equal "100", progress.strip

    assert_match version.to_s, shell_output("#{bin}/pv --version")
  end
end
