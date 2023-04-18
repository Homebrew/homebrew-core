# Jigdo is dead upstream. It consists of two components: Jigdo, a GTK+ using GUI,
# which is LONG dead and completely unfunctional, and jigdo-lite, a command-line
# tool that has been on life support and still works. Only build the CLI tool.
class Jigdo < Formula
  desc "Tool to distribute very large files over the internet"
  homepage "https://www.einval.com/~steve/software/jigdo/"
  url "http://atterer.org/sites/atterer/files/2009-08/jigdo/jigdo-0.7.3.tar.bz2"
  sha256 "875c069abad67ce67d032a9479228acdb37c8162236c0e768369505f264827f0"
  license "GPL-2.0-only" => { with: "openvpn-openssl-exception" }
  revision 8

  livecheck do
    url "https://www.einval.com/~steve/software/jigdo/download/"
    regex(/href=.*?jigdo[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "2a7d61d39591e962966019d3d3925e6ea7799233805253deefa92a531f648cd5"
    sha256 arm64_monterey: "87d951b1c24be108f740eae7378dde28ba28dd7994bfd6758161a6d0bc8bb15d"
    sha256 arm64_big_sur:  "bc9b2ee804e6a0f51b5317ee21f7692b38fe6129b6319037e5bb6069ba80a0f3"
    sha256 ventura:        "39868f6ad957c0a31296e9d82243a905bba103d54f8cd8334acdcd5a17bb29ef"
    sha256 monterey:       "ee860a28d3dc2f0c9c51dbe5e245a048b11cb5fef3b4e71f7846f0c5e014cb4e"
    sha256 big_sur:        "af5dd0ccfda2a1e1e7355c9dd3fab85c4b7024bb8d95b29aa3e0ca84c5d25458"
    sha256 catalina:       "12f14d188a937f63899fd28c436597f15867440d952538f0bc73ee9d9628852d"
    sha256 x86_64_linux:   "fd0973ae7891e7ea56eaffd85a57afd00688c035586fe00856b5b34544a5f3d4"
  end

  depends_on "pkg-config" => :build
  depends_on "berkeley-db@5" # keep berkeley-db < 6 to avoid AGPL incompatibility
  depends_on "wget"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  # Use MacPorts patch for compilation on 10.9. Remove when updating to 0.8+.
  patch :p0 do
    on_macos do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/e101570/jigdo/patch-src-compat.hh.diff"
      sha256 "a21aa8bcc5a03a6daf47e0ab4e04f16e611e787a7ada7a6a87c8def738585646"
    end
  end

  # Use Fedora patch for compilation with GCC. Remove when updating to 0.8+.
  patch do
    on_linux do
      url "https://src.fedoraproject.org/rpms/jigdo/raw/27c01e27168b62157e98c7ffad1aa0b4aad405e9/f/jigdo-0.7.3-gcc43.patch"
      sha256 "57e13ca6c283cb086d1c5ceb5ed3562fab548fa19e1d14ecc045c3a23fa7d44a"
    end
  end

  def install
    system "./configure", *std_configure_args,
                          "--disable-x11",
                          "--mandir=#{man}"
    system "make"
    system "make", "install"
  end

  test do
    assert_match "version #{version}", shell_output("#{bin}/jigdo-file -v")
  end
end
