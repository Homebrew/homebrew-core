class Mkvtoolnix < Formula
  desc "Matroska media files manipulation tools"
  homepage "https://mkvtoolnix.download/"
  url "https://mkvtoolnix.download/sources/mkvtoolnix-104.0.tar.xz"
  mirror "https://fossies.org/linux/misc/mkvtoolnix-104.0.tar.xz"
  sha256 "8f07b39d6cea1aad029f253e0e6e6a54c0e0f3ba91bfc3b2157915630d48a62b"
  license "GPL-2.0-or-later"
  compatibility_version 1

  livecheck do
    url "https://mkvtoolnix.download/sources/"
    regex(/href=.*?mkvtoolnix[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    manifest_sha256 "8386fbc2fc2e38948460d19d1cd22a36e9261dca7b76bbc0a40c769de3c9d840"
    sha256 cellar: :any, arm64_golden_gate: "ea821b71369fee9a9998aafddd5ea40d880fcd30785effd5483b647fd85b67b6"
    sha256 cellar: :any, arm64_tahoe:       "c77489e8a4c7f14b0605fd63a6027447c9ea9f320596905e78b08d19a04f88c6"
    sha256 cellar: :any, arm64_sequoia:     "9a8119d0aacce247a2a7329477c270eb5dc8f8d521e05f2890c865df49db732a"
    sha256               arm64_linux:       "387914e1da192c76d4026c015462e3dbaa131f08502e96b9f1cd1b4ff67ecee6"
    sha256               x86_64_linux:      "e370490eaff1b0d05376a170367306a35c9109254faf4ab2590345fe417609be"
  end

  head do
    url "https://codeberg.org/mbunkus/mkvtoolnix.git", branch: "main"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "docbook-xsl" => :build
  depends_on "gettext" => :build
  depends_on "nlohmann-json" => :build
  depends_on "pkgconf" => :build
  depends_on "utf8cpp" => :build
  depends_on "boost"
  depends_on "flac"
  depends_on "fmt"
  depends_on "gmp"
  depends_on "libebml"
  depends_on "libmatroska"
  depends_on "libogg"
  depends_on "libvorbis"
  depends_on "pugixml"
  depends_on "qtbase"

  uses_from_macos "libxslt" => :build
  uses_from_macos "ruby" => :build

  on_macos do
    depends_on "gettext"
  end

  on_linux do
    depends_on "zlib-ng-compat"
  end

  deny_network_access!

  def install
    # Remove bundled libraries
    rm_r(buildpath.glob("lib/*") - buildpath.glob("lib/{avilib,librmff}*"))

    # Configure script needs help with C++ standard in Boost Math
    ENV.append "CXXFLAGS", "-std=c++20"

    features = %w[flac gmp libebml libmatroska libogg libvorbis]
    extra_includes = ""
    extra_libs = ""
    features.each do |feature|
      extra_includes << "#{formula_opt_include(feature)};"
      extra_libs << "#{formula_opt_lib(feature)};"
    end
    extra_includes << "#{formula_opt_include("utf8cpp")}/utf8cpp;"
    extra_includes.chop!
    extra_libs.chop!

    system "./autogen.sh" if build.head?
    system "./configure", "--with-boost=#{formula_opt_prefix("boost")}",
                          "--with-docbook-xsl-root=#{formula_opt_prefix("docbook-xsl")}/docbook-xsl",
                          "--with-extra-includes=#{extra_includes}",
                          "--with-extra-libs=#{extra_libs}",
                          "--disable-gui",
                          *std_configure_args
    system "rake", "-j#{ENV.make_jobs}"
    system "rake", "install"
  end

  test do
    mkv_path = testpath/"Great.Movie.mkv"
    sub_path = testpath/"subtitles.srt"
    sub_path.write <<~EOS
      1
      00:00:10,500 --> 00:00:13,000
      Homebrew
    EOS

    system bin/"mkvmerge", "-o", mkv_path, sub_path
    system bin/"mkvinfo", mkv_path
    system bin/"mkvextract", "tracks", mkv_path, "0:#{sub_path}"
  end
end
