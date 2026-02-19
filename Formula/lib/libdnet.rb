class Libdnet < Formula
  desc "Portable low-level networking library"
  homepage "https://github.com/ofalk/libdnet"
  url "https://github.com/ofalk/libdnet/archive/refs/tags/libdnet-1.18.2.tar.gz"
  sha256 "95611c6d2703f1772fc01ce74acf4ebcc4bcd4315cede35b343bb90dc43bfd8f"
  license "BSD-3-Clause"

  livecheck do
    url :homepage
    regex(/^libdnet[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c5adbc4b8990d50dab5b5f67507a931b799f34dcc0bb3a8406548211916c8f99"
    sha256 cellar: :any,                 arm64_sequoia: "efd268147fe09068e5168f915767f33fafc8b396fb8db601bc336f991fce6eb1"
    sha256 cellar: :any,                 arm64_sonoma:  "4ff8a092a123cfb092a73b682fea57c92758834ba0fa99c2b5148c0926f9b80d"
    sha256 cellar: :any,                 sonoma:        "97e04e6e85014852cc63d8dfe736b0fe14e049e3d878fbc58922325129edf504"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "239d77702647d67a3b413714db129ba8e94d624fb48d819099ed4a78d910c1b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b272ad6743af2c89e44ecfa3514d0295f3dc3f1a97ce87796983a27de30411a7"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build

  def install
    # autoreconf to get '.dylib' extension on shared lib
    ENV.append_path "ACLOCAL_PATH", "config"
    system "autoreconf", "--force", "--install", "--verbose"

    system "./configure", "--mandir=#{man}", "--disable-check", *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"dnet-config", "--version"
  end
end
