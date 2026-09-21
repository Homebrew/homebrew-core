class MscGenerator < Formula
  desc "Draws signalling charts from textual description"
  homepage "https://gitlab.com/msc-generator/msc-generator"
  url "https://gitlab.com/api/v4/projects/31167732/packages/generic/msc-generator/8.6.4/msc-generator-8.6.4.tar.gz"
  sha256 "499d8e234dae13ae6b551cb8991b6f4db980bb0f69705501e7505aad01ca5e95"
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
    sha256 arm64_golden_gate: "791cf09e9ae47908933dddc7a4fd781362f6c3aed18dcae8456a933e787de271"
    sha256 arm64_tahoe:       "9863a4e3cf0c45e8ff8a6978cc9dd3e63cab38ec15df9c4fc9ac6dac7a40081a"
    sha256 arm64_sequoia:     "5c8f6d9d99c3f6d845700894e19a190016a8a4a3b8e6eb34cbe3c097c2e495c7"
    sha256 arm64_sonoma:      "9d462970ade1e232f9625e5423b1ce607d2a57a99ac54d733513d21b61a31fe1"
    sha256 arm64_linux:       "91c5165105dd4a78f2ee7ab12dc3e29e78d75e59787ded3e1607ed538ae62d6f"
    sha256 x86_64_linux:      "86c897515b9745f57ef86b8bfe46c9296d708c7ca97cfbcff31f0d4f1d250443"
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
