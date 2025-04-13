class MscGenerator < Formula
  desc "Draws signalling charts from textual description"
  homepage "https://gitlab.com/msc-generator/msc-generator"
  url "https://gitlab.com/api/v4/projects/31167732/packages/generic/msc-generator/8.6.2/msc-generator-8.6.2.tar.gz"
  sha256 "7d565cf5ff39e2ecb04d29daec0eaf674278f6d0a1cb507eed580fe8bc8a0893"
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
    sha256 arm64_sequoia: "c1f15322760c6c6832f4391aa34e426e3107322cf0150b38ecb504e66c7f0229"
    sha256 arm64_sonoma:  "0099d9bdd7c1cfce442bd16cbc462126e9ea9d8407d8c40538edfcde102f0c57"
    sha256 arm64_ventura: "d825f247ee7805fb1a8bb12019c2414ddb0ccb08bd93a775945d0283084a4aae"
    sha256 sonoma:        "f21ce8e7b8f247951fd1c3dcb46bc8e5ba8f1913da99a1254f93ad39fcf9f015"
    sha256 ventura:       "602abed907a5dae536b0c0857dfd7b08c46783c5c0eb09897025075c1f122cfe"
    sha256 arm64_linux:   "ea6647b991286227f59ef2ea715c4f92dced7a42a8cf53e8466614a3c3965448"
    sha256 x86_64_linux:  "c60b5ba0e5437cee822f8cea5b1c6687711e87278a7ac2e09b36d02650286d95"
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
