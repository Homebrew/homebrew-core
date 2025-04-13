class Libint < Formula
  desc "Library for computing electron repulsion integrals efficiently"
  homepage "https://github.com/evaleev/libint"
  url "https://github.com/evaleev/libint/archive/refs/tags/v2.10.2.tar.gz"
  sha256 "9a4dfcdba51c988566e187c119339b9aaee41185a02fdaa304ab4757d28e0acc"
  license all_of: ["GPL-3.0-or-later", "LGPL-3.0-or-later"]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "534a0dbaa6794c291b25fd7faf4e659c560b03c13669cda61d360d80388d2a32"
    sha256 cellar: :any,                 arm64_sonoma:  "7576b683eb383a93dad8de11d819523d5c0242f22f920bdb29d3003feecac770"
    sha256 cellar: :any,                 arm64_ventura: "db5d72c5962a06036365002e62c81c307c5a162a085ab69f1d6cd518608a5b70"
    sha256 cellar: :any,                 sonoma:        "d17eb29754941b257cf2ee6f13c55fa5181304751f4a2a3ad0b1e66376e4fd30"
    sha256 cellar: :any,                 ventura:       "3c5bfcdddd76047b1dad9e1f0d513928f79f9c48c33778a00fc769e53d6fc713"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c8ca1a11a0196f72b37c631bc7409ce1c583ad56f30af6b5e270e8085e4aa654"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9d8fa271b3daba7fa878c254197c4ed60745c67bcf68d649ce21787cf468c442"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => [:build, :test]
  depends_on "boost"
  depends_on "eigen"
  depends_on "mpfr"

  def install
    system "glibtoolize", "--install", "--force"
    system "./autogen.sh"
    system "./configure", "--enable-shared", "--disable-static", *std_configure_args
    system "make"
    system "make", "install"
    pkgshare.install "tests/hartree-fock/hartree-fock.cc"
    pkgshare.install "tests/hartree-fock/h2o.xyz"
  end

  test do
    system ENV.cxx, "-std=c++11", pkgshare/"hartree-fock.cc", "-o", "hartree-fock",
                    "-I#{Formula["eigen"].opt_include}/eigen3",
                    *shell_output("pkgconf --cflags --libs libint2").chomp.split
    system "./hartree-fock", pkgshare/"h2o.xyz"
  end
end
