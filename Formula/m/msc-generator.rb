class MscGenerator < Formula
  desc "Draws signalling charts from textual description"
  homepage "https://gitlab.com/msc-generator/msc-generator"
  url "https://gitlab.com/api/v4/projects/31167732/packages/generic/msc-generator/8.5/msc-generator-8.5.tar.gz"
  sha256 "134da30f58458a5ddda0cf6c7a43872636dfc6cae1b8e8a02efe28a0cc9f35d3"
  license "AGPL-3.0-or-later"
  revision 1

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
    sha256 arm64_sonoma:   "b79054b74a26b3399dbc2dfd03ab5b4f08b8000930aa47bca1bf011771f62095"
    sha256 arm64_ventura:  "44858dc437fd4c0b5eded8cba714a3ea24f8cff1e222227e6a860565ddd00f31"
    sha256 arm64_monterey: "c4edbe1ee76e8d8d8a288947de4801ca24d34872addd1507a88c07eeace09a0f"
    sha256 sonoma:         "0301617bb99084da55aeef04d903745903a6a028e14e12b22b33cc7f487fbd33"
    sha256 ventura:        "434e60dbd056048910b1405a61591cb73271e5696e7c88e4d3bdc380dcc8ec14"
    sha256 monterey:       "10d9efd0d5201466d9b35d5419c4df6963431eb3ab991d113d6be7a644d5db44"
    sha256 x86_64_linux:   "87d19390e344e2652c93ce0c396892588deb488748336a84156378bf8de51e4a"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "bison" => :build
  depends_on "help2man" => :build
  depends_on "pkg-config" => :build
  depends_on "cairo"
  depends_on "glpk"
  depends_on "graphviz"
  depends_on "sdl2"
  depends_on "tinyxml2"

  on_macos do
    # Some upstream sed discussions in https://gitlab.com/msc-generator/msc-generator/-/issues/92
    depends_on "gnu-sed" => :build
    depends_on "make" => :build # needs make 4.3+
    depends_on "gcc"
  end

  on_linux do
    depends_on "mesa"
  end

  fails_with :clang # needs std::range

  fails_with :gcc do
    version "9"
    cause "needs std::range"
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
    system "#{bin}/msc-gen", "--version"
    # Construct a simple chart and check if PNG is generated (the default output format)
    (testpath/"simple.signalling").write("a->b;")
    system "#{bin}/msc-gen", "simple.signalling"
    assert_predicate testpath/"simple.png", :exist?
    bytes = File.binread(testpath/"simple.png")
    assert_equal bytes[0..7], "\x89PNG\r\n\x1a\n".force_encoding("ASCII-8BIT")
  end
end
