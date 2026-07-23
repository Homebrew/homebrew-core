class MscGenerator < Formula
  desc "Draws signalling charts from textual description"
  homepage "https://gitlab.com/msc-generator/msc-generator"
  url "https://gitlab.com/api/v4/projects/31167732/packages/generic/msc-generator/8.6.4/msc-generator-8.6.4.tar.gz"
  sha256 "499d8e234dae13ae6b551cb8991b6f4db980bb0f69705501e7505aad01ca5e95"
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
    rebuild 1
    sha256 arm64_tahoe:   "da6b02da65c156fad03acf190e947d13116848bed3cb93af038be2659c8750b1"
    sha256 arm64_sequoia: "3704e725252a494693cece5391dce8a8c966a6ef9841fa52eb69939a9ec31106"
    sha256 arm64_sonoma:  "ab8965fd245e03fa88e1d6009a35910376bcd3fecb9870fa5054a7e1c920699e"
    sha256 sonoma:        "4922c995be679a10e74c100ca1ece8527120d5d2b830b1ae12e76089d6c9b393"
    sha256 arm64_linux:   "9665fda4d8a10b843b86a7a907b18e72f04e8c9592bc7f31bef7a5f1d5961f63"
    sha256 x86_64_linux:  "0497fb347a903cfdb1344f3561c4f8bfa7ed8f0fa3b69f803406e4192cdd95be"
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
  depends_on "sdl2-compat"
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
      ENV.prepend_path "PATH", formula_opt_libexec("gnu-sed")/"gnubin"
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
