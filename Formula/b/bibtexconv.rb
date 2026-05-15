class Bibtexconv < Formula
  desc "BibTeX file converter"
  homepage "https://github.com/dreibh/bibtexconv"
  url "https://github.com/dreibh/bibtexconv/archive/refs/tags/bibtexconv-2.2.1.tar.gz"
  sha256 "6c311b6e4154c9286e43a47a4691efcceb99ffe11a0d0f63a63a8ebbc2023b96"
  license "GPL-3.0-or-later"
  head "https://github.com/dreibh/bibtexconv.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "37b7a0937dccd811fdf3313326221beeb2ff38411bb40923e5cd4ca5c0fdb417"
    sha256 cellar: :any,                 arm64_sequoia: "802fdd38abee7f99a986115fad2f01546113791c7c1c1a8615c93f54554d4db1"
    sha256 cellar: :any,                 arm64_sonoma:  "4464f6dfe995ebd1dbdffdaea8534a47017ae4f4e0ee55960346ec8bc27aee1f"
    sha256 cellar: :any,                 sonoma:        "ce670046eb1d4e1017ce6773b30049f16d2e1caa194621def0720eec09437548"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f6674170da47b9dcd995fa7b3df2e0da04cc877e16ee99d54110d61033fbd1db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f6c7d21af85795870e4fa7e35222ce4dff91d23fbc38aa131f74eade2e8ccefb"
  end

  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "openssl@3"

  uses_from_macos "flex" => :build
  uses_from_macos "curl"

  on_macos do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version <= 1600
  end

  fails_with :clang do
    build 1600
  end

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args,
                    "-DCRYPTO_LIBRARY=#{Formula["openssl@3"].opt_lib}/#{shared_library("libcrypto")}"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    cp "#{opt_share}/doc/bibtexconv/examples/ExampleReferences.bib", testpath

    system bin/"bibtexconv", testpath/"ExampleReferences.bib",
                             "-export-to-bibtex=UpdatedReferences.bib",
                             "-check-urls", "-only-check-new-urls",
                             "-non-interactive"
  end
end
