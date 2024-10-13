class MscGenerator < Formula
  desc "Draws signalling charts from textual description"
  homepage "https://gitlab.com/msc-generator/msc-generator"
  url "https://gitlab.com/api/v4/projects/31167732/packages/generic/msc-generator/8.6.2/msc-generator-8.6.2.tar.gz"
  sha256 "7d565cf5ff39e2ecb04d29daec0eaf674278f6d0a1cb507eed580fe8bc8a0893"
  license "AGPL-3.0-or-later"

  livecheck do
    url "https://gitlab.com/api/v4/projects/31167732/packages"
    strategy :json do |json|
      json.map do |item|
        next unless item["name"]&.downcase&.include?("msc-generator")

        item["version"]
      end
    end
  end

  bottle do
    sha256 arm64_sequoia:  "1bb7414a5ad949e5a749e09c6a536a41cf7bfa40c8719b7b8a6280f0f227fb8c"
    sha256 arm64_sonoma:   "5f94fd009e0b2fd06ed13995705298907f56a32111a9d4c489c49abf7519be72"
    sha256 arm64_ventura:  "1226239916c31e57bc51801d867655d282a32258141dd3a63d698b5569d4312f"
    sha256 arm64_monterey: "81caf56a7e9225793493479648d42c6233f0eca6892f11ce0e8dd21b95b3c99d"
    sha256 sonoma:         "4b3319591e9619626d4c259fd4c22bdf68e6c025174a433a69c98891deb6b581"
    sha256 ventura:        "12ef3f1a32694a0cd00547eee5e65096d1dc99d2eb33e68973865cffc70e730a"
    sha256 monterey:       "56419db7a86687d8aca908bf5e62c7ffda0f373a4c97670bbdadf2819ff94f04"
    sha256 x86_64_linux:   "b679c4ec1606b7be9c65ba4d7e320b3a48eb7f5bac32374315448ee871e0ec1a"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "bison" => :build
  depends_on "help2man" => :build
  depends_on "pkg-config" => :build
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
    assert_predicate testpath/"simple.png", :exist?
    bytes = File.binread(testpath/"simple.png")
    assert_equal bytes[0..7], "\x89PNG\r\n\x1a\n".force_encoding("ASCII-8BIT")
  end
end
