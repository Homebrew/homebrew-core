class MscGenerator < Formula
  desc "Draws signalling charts from textual description"
  homepage "https://gitlab.com/msc-generator/msc-generator"
  url "https://gitlab.com/api/v4/projects/31167732/packages/generic/msc-generator/8.6.2/msc-generator-8.6.2.tar.gz"
  sha256 "7d565cf5ff39e2ecb04d29daec0eaf674278f6d0a1cb507eed580fe8bc8a0893"
  license "AGPL-3.0-or-later"
  revision 2

  livecheck do
    url "https://gitlab.com/api/v4/projects/31167732/packages"
    strategy :json do |json|
      json.map do |item|
        next unless item["name"]&.downcase&.include?("msc-generator")

        item["version"]
      end
    end
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 arm64_sequoia: "3cdbc7b3e6e76935d8137755cdb09b81330d42975583a5ce2425a2374b200b3a"
    sha256 arm64_sonoma:  "88bdd770e655a3ecc1e658ed6ab9e011f1e191b684fd18b834e678c9b52e942e"
    sha256 arm64_ventura: "ab50303d1a9387e595e09790310a4b750df105ff5aed97923655670ffd380502"
    sha256 sonoma:        "90cbf56c86a7226c2acfab592458ed4f7b3fe6ec8cb1f295c7e4a4cab1219732"
    sha256 ventura:       "5ecfd64dfdf430d0675887a87db3ba5384aa065622f2b27d4df90f64f92e6e95"
    sha256 arm64_linux:   "b9141ada79ad184c1070d5bfadf8b9ff6ab510477f8e30e3f5854c957ed7c065"
    sha256 x86_64_linux:  "f77209ae4d99b827722eda2193aa9265dd27b4679ab4f9a0de405c33e1a0c529"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "bison" => :build
  depends_on "help2man" => :build
  depends_on "pkgconf" => :build
  depends_on "cairo"
  depends_on "fontconfig"
  depends_on "gcc"
  depends_on "glpk"
  depends_on "graphviz"
  depends_on "libpng"
  depends_on "sdl2"
  depends_on "tinyxml2"

  on_macos do
    # Some upstream sed discussions in https://gitlab.com/msc-generator/msc-generator/-/issues/92
    depends_on "gnu-sed" => :build
    depends_on "make" => :build # needs make 4.3+
  end

  on_linux do
    depends_on "mesa"
  end

  fails_with :clang # needs std::range

  fails_with :gcc do
    version "12"
    cause "needs std::range::contains"
  end

  def install
    # Issue ref: https://gitlab.com/msc-generator/msc-generator/-/issues/96
    odie "Check if workarounds for newer GraphViz can be removed!" if version > "8.6.2"
    ENV.append_to_cflags "-DGRAPHVIZ_VER=#{Formula["graphviz"].version.major}00 -DTRUE=1"
    inreplace "src/libgvgen/gvgraphs.cpp", "std::max((float)0, std::min((float)1,", "std::max(0.0, std::min(1.0,"

    args = %w[--disable-font-checks --disable-silent-rules]
    make = "make"

    # Brew uses shims to ensure that the project is built with a single compiler.
    # However, gcc cannot compile our Objective-C++ sources (clipboard.mm), while
    # clang++ cannot compile the rest of the project. As a workaround, we set gcc
    # as the main compiler, and bypass brew's compiler shim to force using clang++
    # for Objective-C++ sources. This workaround should be removed once brew supports
    # setting separate compilers for C/C++ and Objective-C/C++.
    if OS.mac?
      args << "OBJCXX=/usr/bin/clang++"
      ENV.append_to_cflags "-DNDEBUG"
      ENV.prepend_path "PATH", Formula["gnu-sed"].opt_libexec/"gnubin"
      ENV["MAKE"] = make = "gmake"
    end

    system "./configure", *args, *std_configure_args
    system make, "-C", "src", "install"
    system make, "-C", "doc", "msc-gen.1"
    man1.install "doc/msc-gen.1"
  end

  test do
    # Try running the program
    system bin/"msc-gen", "--version"
    # Construct a simple chart and check if PNG is generated (the default output format)
    (testpath/"simple.signalling").write("a->b;")
    system bin/"msc-gen", "simple.signalling"
    assert_path_exists testpath/"simple.png"
    bytes = File.binread(testpath/"simple.png")
    assert_equal bytes[0..7], "\x89PNG\r\n\x1a\n".force_encoding("ASCII-8BIT")
  end
end
