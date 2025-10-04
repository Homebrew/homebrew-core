class MscGenerator < Formula
  desc "Draws signalling charts from textual description"
  homepage "https://gitlab.com/msc-generator/msc-generator"
  url "https://gitlab.com/api/v4/projects/31167732/packages/generic/msc-generator/8.6.3/msc-generator-8.6.3.tar.gz"
  sha256 "476115a4f4dc3f71fae43071c388db6323bf2298f9d3b6f5214557a570ceacf2"
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

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 arm64_tahoe:   "f59601f0cbde128e5bf006d6e209896fece79956672e1b68530d7fd32a9fa7fd"
    sha256 arm64_sequoia: "85bcc5cfd7b8b439e17e4d1b438f99dd79efabef69a5d7c919bd4d5bc3892636"
    sha256 arm64_sonoma:  "1cdf8e111c43a0104afa5ef43307adad58eb9f67eab664e751b316d789115617"
    sha256 sonoma:        "72a0c8f7c7f666b4ba4bb963be292959be2a8d7c77d58aee15d58c4d6a51c932"
    sha256 arm64_linux:   "02f3c6b42be051258a634306df0100e10dabcfc8dd4113978f4629488d1b4340"
    sha256 x86_64_linux:  "dbb32f6692261fcf51d8a8b07e4c45d93189ad0565251ae4f3783a9ae3d5aaaa"
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
