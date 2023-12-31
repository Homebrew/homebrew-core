class ArgusClients < Formula
  desc "Audit Record Generation and Utilization System clients"
  homepage "https://openargus.org"
  url "https://github.com/openargus/clients/archive/refs/tags/v3.0.8.4.tar.gz"
  sha256 "1e71e1ec84a311af4ac6c6c9e7a3231e10591e215b84d7e0841735b11db3127a"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "b0587f8a46452c38ec031e8702f2187cbf691da6967f2d9201d26cd20a231b65"
    sha256 cellar: :any,                 arm64_ventura:  "6851559033bb84f190d0e81c9449f69b5ba38c1e0683f4f3811595934334054d"
    sha256 cellar: :any,                 arm64_monterey: "ef5843ccd0c438284b0c21fa0d70ccac9ab8d06f8ee1eba59752027476bf55e9"
    sha256 cellar: :any,                 sonoma:         "ae69489900b4e3f9292a1e1f2f33ac21070b0e7c3f3abf161eae9f0693d4acbd"
    sha256 cellar: :any,                 ventura:        "34584bff62553297be082fc641dc4547ce5078d0d062271a19a5e596fe389883"
    sha256 cellar: :any,                 monterey:       "cd5dd677729938a48bec1da1d3a12ca26269a107a5bdac2b76d47968d453d58a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9810d90c908373e299c23598590268144b3cc35c15ecf5e73fb8dcc300af4411"
  end

  depends_on "readline"
  depends_on "rrdtool"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build

  on_linux do
    depends_on "libtirpc"
  end

  def install
    ENV.append_to_cflags "-I#{Formula["libtirpc"].opt_include}/tirpc" if OS.linux?
    ENV.append "CFLAGS", "-std=gnu89"
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    assert_match "Ra Version #{version}", shell_output("#{bin}/ra -h", 1)
  end
end
