class Fastfec < Formula
  desc "Extremely fast FEC filing parser written in C"
  homepage "https://github.com/washingtonpost/FastFEC"
  url "https://github.com/washingtonpost/FastFEC/archive/refs/tags/0.0.4.tar.gz"
  sha256 "8c508e0a93416a1ce5609536152dcbdab0df414c3f3a791e11789298455d1c71"
  license "MIT"

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
