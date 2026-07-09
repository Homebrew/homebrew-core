class Bibtexconv < Formula
  desc "BibTeX file converter"
  homepage "https://www.nntb.no/~dreibh/bibtexconv/"
  url "https://github.com/dreibh/bibtexconv/archive/refs/tags/bibtexconv-2.2.3.tar.gz"
  sha256 "fa2e280d5653bef78a003f09cbb6efb2a64c25261964ccfcc8be6d4029548565"
  license "GPL-3.0-or-later"
  head "https://github.com/dreibh/bibtexconv.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "b88bef8dd55698cb12cec26c62fda795c5e6c0b2508e03b8c7bd2a4fd4bff457"
    sha256 cellar: :any, arm64_sequoia: "4afe3fe4173943858e92448cbb403d0d0c8631e5a50a0877df5d422fd9718dae"
    sha256 cellar: :any, arm64_sonoma:  "ae8b949431cc8108acbd9b9135ef4a670031c913c662d356e2f9691e0c68b9bb"
    sha256 cellar: :any, sonoma:        "cb55e6e6f209ce757930f062c12371d90375cac3d0cb82931165a76303f47a29"
    sha256 cellar: :any, arm64_linux:   "1e2513dd4dfd6d36fa8179bc29d8604357ff0059763bb70dab5d343fa6bcbc42"
    sha256 cellar: :any, x86_64_linux:  "a345a5aec2e2e87545ac9d488cd8b9988fd782a4429a2b2609974caef0732c1d"
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
                    "-DCRYPTO_LIBRARY=#{formula_opt_lib("openssl@3")}/#{shared_library("libcrypto")}"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    cp "#{opt_share}/doc/bibtexconv/examples/ExampleReferences.bib", testpath

    system bin/"bibtexconv", testpath/"ExampleReferences.bib",
                             "--export-to-bibtex", "UpdatedReferences.bib",
                             "--check-urls", "--only-check-new-urls",
                             "--non-interactive"
  end
end
