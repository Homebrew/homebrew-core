class Got < Formula
  desc "Version control system"
  homepage "https://gameoftrees.org/"
  url "https://gameoftrees.org/releases/portable/got-portable-0.120.tar.gz"
  mirror "https://pkg.freebsd.org/ports-distfiles/got-portable-0.120.tar.gz"
  sha256 "b7a60c6761f6dc2810f676606a2b32eb7631c17a96dcc74b8d99b67b91e89f43"
  license "ISC"

  # Since GitHub runners are not able to access the homepage, our Linux build
  # requires FreeBSD mirror to exist before we can bump the version.
  livecheck do
    url "https://raw.githubusercontent.com/freebsd/freebsd-ports/refs/heads/main/devel/got/distinfo"
    regex(/got-portable[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: "GitHub runners are not abile to access the homepage or livecheck URL"

  bottle do
    sha256 arm64_tahoe:   "bf76c719e1d6732fe4db46638666b85204dc39871b5d2c2d09fbda82e69443ca"
    sha256 arm64_sequoia: "c0bd6ef9fdc5bdeaa8513f79d7f8372ed6e5a2989b7abe15597a795fed877231"
    sha256 arm64_sonoma:  "b09db6cd72550be0e69c45df893f73ee155e10a3bb18edcfc08ecdc9d58d054d"
    sha256 sonoma:        "4f62cc6596e872e8f1caec07226060cd2a7d1b895d59b4ac4590d6d6501a4092"
    sha256 arm64_linux:   "5284b3a3ac65cb796671daaa0171800c17ab6dc3a1f893f0740ee95508156ede"
    sha256 x86_64_linux:  "3a8eba1a5dccf3b0f003eeb0dd45797d88f58ec611d581b9c84e433c0b6f75e9"
  end

  depends_on "bison" => :build
  depends_on "pkgconf" => :build
  depends_on "libevent"
  depends_on "libretls"
  depends_on "ncurses"
  depends_on "openssl@3"

  uses_from_macos "zlib"

  on_linux do
    depends_on "libbsd"
    depends_on "libmd"
    depends_on "util-linux" # for libuuid
  end

  def install
    ENV["LIBTLS_CFLAGS"] = "-I#{Formula["libretls"].opt_include}"
    ENV["LIBTLS_LIBS"] = "-L#{Formula["libretls"].opt_lib} -ltls"
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  test do
    ENV["GOT_AUTHOR"] = "Flan Hacker <flan_hacker@openbsd.org>"
    system bin/"gotadmin", "init", "repo.git"
    mkdir "import-dir"
    %w[haunted house].each { |f| touch testpath/"import-dir"/f }
    system bin/"got", "import", "-m", "Initial Commit", "-r", "repo.git", "import-dir"
    system bin/"got", "checkout", "repo.git", "src"
  end
end
