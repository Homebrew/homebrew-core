class Bibtexconv < Formula
  desc "BibTeX file converter"
  homepage "https://github.com/dreibh/bibtexconv"
  url "https://github.com/dreibh/bibtexconv/archive/refs/tags/bibtexconv-1.4.5.tar.gz"
  sha256 "b198d41c0f83011163dd8a0388b06fcca86c8210920483e787ebd07fc09c5eef"
  license "GPL-3.0-or-later"
  head "https://github.com/dreibh/bibtexconv.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "62e4f8de96e91df024c4399e6f96cb934aee116b5d580b49bf8f7d96ebc0be87"
    sha256 cellar: :any,                 arm64_sonoma:  "2ad45fad9ff8eb20fe21f9cc66ec9b442960667b05227e1cf367040dbd76af81"
    sha256 cellar: :any,                 arm64_ventura: "8c45e24c01ce7937809c5113e12ca6bb8394ff6c9f4d07cef824d2309faabe45"
    sha256 cellar: :any,                 sonoma:        "d2b1a3159517bd7a05000834ed1ed1c755889617edac9039c6b04b35ad1c56ad"
    sha256 cellar: :any,                 ventura:       "ba9dfd0c21b7decd8e82d53672ad15c2d359e42f935ec27017ca11713eccb663"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "23c27733ef8c40165810742305fdd194abe219365eb0a7e19fbd34c835014f88"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8b6636010426b45bd161434ffdebe73b20ea0db6e1c84936b0f3b7420997c276"
  end

  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "openssl@3"

  uses_from_macos "flex" => :build
  uses_from_macos "curl"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args,
                    "-DCRYPTO_LIBRARY=#{Formula["openssl@3"].opt_lib}/#{shared_library("libcrypto")}"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    cp "#{opt_share}/doc/bibtexconv/examples/ExampleReferences.bib", testpath

    system bin/"bibtexconv", "#{testpath}/ExampleReferences.bib",
                             "-export-to-bibtex=UpdatedReferences.bib",
                             "-check-urls", "-only-check-new-urls",
                             "-non-interactive"
  end
end
