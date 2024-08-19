class C3c < Formula
  desc "Compiler for the C3 language"
  homepage "https://github.com/c3lang/c3c"
  url "https://github.com/c3lang/c3c/archive/refs/tags/v0.6.1.tar.gz"
  sha256 "472c5026b7bf9c709208d31f3a9ae3eba920dc5a78293356a6194fca463f42f1"
  license "LGPL-3.0-only"
  head "https://github.com/c3lang/c3c.git", branch: "master"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "ff108e3793c26142c04c07225d53df7c584a92e1ce09c38ef2fd6ba740ca0d79"
    sha256 cellar: :any,                 arm64_ventura:  "15cf0dbfc9723a79a382b9bf4fd1804d02c5e7ba45462ff445cc6e76910c1ac6"
    sha256 cellar: :any,                 arm64_monterey: "3c7109c6b9bb49a74dfc094317dcba1fb59eb3f75e91e40f81b7ff325d8c3e2b"
    sha256 cellar: :any,                 sonoma:         "4ebc81a1844f6db060b5c2497e71bff1968d97110a69528e917ff8cb230275af"
    sha256 cellar: :any,                 ventura:        "d5d8d8559ff29535a66e5432c33cc93e5ae4eaf027a5ad19379743c03538d215"
    sha256 cellar: :any,                 monterey:       "75e72eed67a560b9246e4d386d2215c973baeaf7d37cf5a849c4b8e7a534277c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "445b92d08fba1888c8a3e579f5f4055608c0f783237c1372a8dab678c1903854"
  end

  depends_on "cmake" => :build
  depends_on "llvm"
  depends_on "z3"
  depends_on "zstd"

  uses_from_macos "curl"
  uses_from_macos "libedit"
  uses_from_macos "libxml2"
  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c3").write <<~EOS
      module hello_world;
      import std::io;

      fn void main()
      {
        io::printn("Hello, world!");
      }
    EOS
    system bin/"c3c", "compile", "test.c3", "-o", "test"
    assert_match "Hello, world!", shell_output("#{testpath}/test")
  end
end
