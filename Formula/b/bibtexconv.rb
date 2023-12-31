class Bibtexconv < Formula
  desc "BibTeX file converter"
  homepage "https://github.com/dreibh/bibtexconv"
  url "https://github.com/dreibh/bibtexconv/archive/refs/tags/bibtexconv-1.3.6.tar.gz"
  sha256 "09450e05693ac230b9f9b9a9486bb1ae5bb2f9aafd072d2b830b9f2d2d69382d"
  license "GPL-3.0-or-later"
  head "https://github.com/dreibh/bibtexconv.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "836e88ffc37dbb3193b6eb4a1cbc284dbe378944e440efa34757e89b5fc2deff"
    sha256 cellar: :any,                 arm64_ventura:  "beccc84ee1c503d869596529b071b5f14d04e12a2a01b1c75fb43b59d939938b"
    sha256 cellar: :any,                 arm64_monterey: "7bd84bec4c08c2e4b60288cca3de0ecd4442c9d71ea03a7892b1960757f46ccd"
    sha256 cellar: :any,                 sonoma:         "b97e64f3767297d3d8595d1f37b1c8e0c79f8b179bc878a50b4f40a75260a0d2"
    sha256 cellar: :any,                 ventura:        "648e71420b87d35737527d8feb4de06dc429467bf832b58c2696b060ed4f677d"
    sha256 cellar: :any,                 monterey:       "aaeb22d4747969ea619d841c4b426a664b7a5c697eb70aab22848c82cdb16d03"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "827e1b69a16fe6a72b86a289cf2c2d261f767ecef353d7e6b7b672c9a9766774"
  end

  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "openssl@3"

  uses_from_macos "flex" => :build
  uses_from_macos "curl"

  def install
    system "cmake", *std_cmake_args,
                    "-DCRYPTO_LIBRARY=#{Formula["openssl@3"].opt_lib}/#{shared_library("libcrypto")}"
    system "make", "install"
  end

  test do
    cp "#{opt_share}/doc/bibtexconv/examples/ExampleReferences.bib", testpath

    system bin/"bibtexconv", "#{testpath}/ExampleReferences.bib",
                             "-export-to-bibtex=UpdatedReferences.bib",
                             "-check-urls", "-only-check-new-urls",
                             "-non-interactive"
  end
end
