class Libgit2Glib < Formula
  desc "Glib wrapper library around libgit2 git access library"
  homepage "https://github.com/GNOME/libgit2-glib"
  url "https://download.gnome.org/sources/libgit2-glib/0.24/libgit2-glib-0.24.4.tar.xz"
  sha256 "3a211f756f250042f352b3070e7314a048c88e785dba9d118b851253a7c60220"
  revision 3

  bottle do
    sha256 "a3875f6cff1685ada0b599143fc056493fabeed883a7e090a4cc052ba0f112b2" => :sierra
    sha256 "ac432f38fedea1228635476acbc841e01dd680865f6381d25e67784177f67390" => :el_capitan
    sha256 "0104b532f15fa9cbd971b047ebcabe198efd01679f6cf2e5ba27debc95b6a1a2" => :yosemite
  end

  head do
    url "https://github.com/GNOME/libgit2-glib.git"

    depends_on "libtool" => :build
    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "gnome-common" => :build
    depends_on "gtk-doc" => :build
  end

  depends_on "cmake" => :build # for libgit2
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "libssh2" # for libgit2
  depends_on "gobject-introspection"
  depends_on "glib"
  depends_on "vala" => :optional
  depends_on :python => :optional

  # Re-evaluate when > 0.24.4 is released
  # Vendor libgit2 0.24.x since libgit2-glib isn't compatible with 0.25.x yet
  # Reported 28 Dec 2016 https://bugzilla.gnome.org/show_bug.cgi?id=776506
  resource "libgit2" do
    url "https://github.com/libgit2/libgit2/archive/v0.24.6.tar.gz"
    sha256 "7b441a96967ff525e790f8b66859faba5c6be4c347124011f536ae9075ebc30c"
  end

  def install
    resource("libgit2").stage do
      args = std_cmake_args - ["-DCMAKE_INSTALL_PREFIX=#{prefix}"]
      args << "-DCMAKE_INSTALL_PREFIX=#{libexec}/libgit2"
      args << "-DBUILD_CLAR=NO" # Don't build the tests

      mkdir "build" do
        system "cmake", "..", *args
        system "make", "install"
      end

      # Prevent "dyld: Library not loaded: libgit2.24.dylib"
      MachO::Tools.change_dylib_id("#{libexec}/libgit2/lib/libgit2.dylib",
                                   "#{libexec}/libgit2/lib/libgit2.dylib")
    end
    ENV.prepend_path "PKG_CONFIG_PATH", libexec/"libgit2/lib/pkgconfig"

    args = %W[
      --prefix=#{prefix}
      --disable-silent-rules
      --disable-dependency-tracking
    ]

    args << "--enable-python=no" if build.without? "python"
    args << "--enable-vala=no" if build.without? "vala"

    system "./autogen.sh", *args if build.head?
    system "./configure", *args if build.stable?
    system "make", "install"

    libexec.install "examples/.libs", "examples/clone", "examples/general", "examples/walk"
  end

  test do
    mkdir "horatio" do
      system "git", "init"
    end
    system "#{libexec}/general", testpath/"horatio"
  end
end
