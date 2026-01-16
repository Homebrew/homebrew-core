class MscGenerator < Formula
  desc "Draws signalling charts from textual description"
  homepage "https://gitlab.com/msc-generator/msc-generator"
  url "https://gitlab.com/api/v4/projects/31167732/packages/generic/msc-generator/8.6.4/msc-generator-8.6.4.tar.gz"
  sha256 "4f9b44f5439c512f95b686755526fd8772aa9df8c52e7e13bd60276a2d558557"
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
    sha256 arm64_tahoe:   "77320a8ba2d8b05c1bb4accb40bb8d8c2863326056916faebd02ec5d6baf7f1e"
    sha256 arm64_sequoia: "d9edc1a402e83f259f311d7b9820ae2d2f25a15aaf2a71fbcab55ad826054823"
    sha256 arm64_sonoma:  "443bfcb59db4bf1b282fd5a3805c16e60026ffd6d2ebeb40fbd67250dfce8d4b"
    sha256 sonoma:        "aaf99db5b0360a364b215c53df1b5976a86afde615ccd62f4453fa779d2fb964"
    sha256 arm64_linux:   "bcf697f0dad4b80dbac6bf30f4de6d20723f0fdacb502eb7d7c3ee61c175df9e"
    sha256 x86_64_linux:  "c4cd3b10cf1a761607bce952b2ce0a67bf003dfee4027feba19ff2c20bb3bb62"
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
