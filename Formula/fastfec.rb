class Fastfec < Formula
  desc "Extremely fast FEC filing parser written in C"
  homepage "https://github.com/washingtonpost/FastFEC"
  url "https://github.com/washingtonpost/FastFEC/archive/refs/tags/0.0.4.tar.gz"
  sha256 "8c508e0a93416a1ce5609536152dcbdab0df414c3f3a791e11789298455d1c71"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_monterey: "319e719a3319eb0743f3c2f4bad9982f856d61ad6e48a12834b18d0824f43db2"
    sha256 cellar: :any, arm64_big_sur:  "ebd69d8e9df72f65268e5edf6df685edbebf9c23efe92460fc991b156719c6fd"
    sha256 cellar: :any, monterey:       "d4419d3e30e3b37fd68efeb77714b96ceac2272681208f6642cb93cccdf1a9f5"
    sha256 cellar: :any, big_sur:        "2077568c25d019f94010d2ffd52d59bfbc99426bd46a40ac790f453325cbf51e"
    sha256 cellar: :any, catalina:       "00b9052385c892e80ca899d30f20fc5884b9987b59566fc68512709b41107735"
    sha256               x86_64_linux:   "20a3766b4146a2279677f2510b066b238eef632c7f19e30c9a589deceaaa6f9a"
  end

  depends_on "pkg-config" => :build
  depends_on "zig" => :build
  depends_on "pcre"
  uses_from_macos "curl"

  def install
    ENV["ZIG_SYSTEM_LINKER_HACK"] = "1"
    args = [
      # Use brew's pcre
      "-Dvendored-pcre=false",
    ]
    if OS.linux?
      args << "--search-prefix"
      args << Formula["curl"].opt_prefix
    end
    system "zig", "build", *args
    bin.install "zig-out/bin/fastfec"
    lib.install "zig-out/lib/#{shared_library("libfastfec")}"
  end

  test do
    system "#{bin}/fastfec", "--no-stdin", "13425"
    assert_predicate testpath/"output/13425/F3XN.csv", :exist?
    assert_predicate testpath/"output/13425/header.csv", :exist?
    assert_predicate testpath/"output/13425/SA11A1.csv", :exist?
    assert_predicate testpath/"output/13425/SB23.csv", :exist?
  end
end
