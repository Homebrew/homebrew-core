class Kore < Formula
  desc "Web application framework for writing web APIs in C"
  homepage "https://kore.io/"
  url "https://kore.io/releases/kore-4.2.2.tar.gz"
  sha256 "77c12d80bb76fe774b16996e6bac6d4ad950070d0816c3409dc0397dfc62725f"
  license "ISC"
  revision 2
  head "https://github.com/jorisvink/kore.git", branch: "master"

  livecheck do
    url "https://kore.io/source"
    regex(/href=.*?kore[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "8a476b2e8a6f1876a3bb0f930b2ee67f440d2fc442dc99e98ee00b9535901b79"
    sha256 arm64_big_sur:  "ebfe4e5da5636545f185e1535ee205389e1b71efc97242565470f72da11f4ac0"
    sha256 monterey:       "ba1b874c9e8d25e1365258664b2e2f8355a587c755a737c84878b98013cb7ce4"
    sha256 big_sur:        "99770a896f403b2f61ca845bc8fcbbb6ea625c62358802d2ab326a5d2f6af67e"
    sha256 catalina:       "ef8323a13116686ae46c44f74f6dfb23a62b168681dc6913b2649fb4f2f96460"
    sha256 x86_64_linux:   "a7be618efc5377bc7b4c5214466e016049273a1f5dcc4ae3d5db820f935f32df"
  end

  depends_on "pkg-config" => :build
  depends_on macos: :sierra # needs clock_gettime
  depends_on "openssl@1.1"

  def install
    ENV.deparallelize { system "make", "PREFIX=#{prefix}", "TASKS=1" }
    system "make", "install", "PREFIX=#{prefix}"

    # Remove openssl cellar references, which breaks kore on openssl updates
    openssl = Formula["openssl@1.1"]
    inreplace [pkgshare/"features", pkgshare/"linker"], openssl.prefix.realpath, openssl.opt_prefix if OS.mac?
  end

  test do
    system bin/"kodev", "create", "test"
    cd "test" do
      system bin/"kodev", "build"
      system bin/"kodev", "clean"
    end
  end
end
