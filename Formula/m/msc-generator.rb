class MscGenerator < Formula
  desc "Draws signalling charts from textual description"
  homepage "https://gitlab.com/msc-generator/msc-generator"
  url "https://gitlab.com/api/v4/projects/31167732/packages/generic/msc-generator/8.6.3/msc-generator-8.6.3.tar.gz"
  sha256 "476115a4f4dc3f71fae43071c388db6323bf2298f9d3b6f5214557a570ceacf2"
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

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 arm64_tahoe:   "8d59c5da7c485ba12851ecfd932bb62ca445a99b40eb46e5e2c7ad9c70216b80"
    sha256 arm64_sequoia: "73a489abffaabce9621c173286b6d2d20ee4e4159cbc6d4e4b1dfe99be8eafc1"
    sha256 arm64_sonoma:  "635cd79d00fa5681b9935b8c0402f1759dc23f5a1450627f84464c83d112283a"
    sha256 arm64_ventura: "70cecf1aeb0ab2c0acb517e09c74087f8a838dafd687d68045968d8973ba0656"
    sha256 sonoma:        "eaab20a72963158bba1aca99b9722a92361eb6f058bcef901c8257b4e01dedb6"
    sha256 ventura:       "f813d36ec015459e51508ddc0d0a3be1641208a48a0aa6a24ee9af84f42d117c"
    sha256 arm64_linux:   "a9cd24c1bbd9cc6b1fabf5a9cf018f1a82e93ea1f0f2b04a076aafb98d2dccd2"
    sha256 x86_64_linux:  "f4d507131178f96240c500639c18dd8df5b6e63e63226bc48c8f3e89a9c5e886"
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
