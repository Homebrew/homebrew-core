class Bibtexconv < Formula
  desc "BibTeX file converter"
  homepage "https://github.com/dreibh/bibtexconv"
  url "https://github.com/dreibh/bibtexconv/archive/refs/tags/bibtexconv-1.4.4.tar.gz"
  sha256 "c6bedbf55fd4dda8fe92c855a8dc64700d58c52da3ec477dc9b69e1e67239b67"
  license "GPL-3.0-or-later"
  head "https://github.com/dreibh/bibtexconv.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "3b0ea898d9383122159b3da49460ed2fa7fdb37f4040b87470cc1f0d550f0878"
    sha256 cellar: :any,                 arm64_sonoma:  "33694a32ab44aa9a1f4372bfd1199d9987695881633d30275cedefefb242420d"
    sha256 cellar: :any,                 arm64_ventura: "4e41ede4b8a0adbfb06b78e726b7b8d09bc1b54601279881f904560a138a2a83"
    sha256 cellar: :any,                 sonoma:        "6a1b98a527523e8d18d473905bccb12de347e26467c9820ca33636e9cb50ec0b"
    sha256 cellar: :any,                 ventura:       "57c4dc89d14f0e97884ab80db98c5a10dcf467e47d406a29bee2ccc79e753e8f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "87d4c74b7df9136aac2821f99c2ad5e62d84ee3d203b4061336c6a3fb9bf6083"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b313fd54d98f2cb37bc77651c8c4d68ac8ed799a0f45bbfd3b99dab016352d52"
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
