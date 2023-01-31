class CmarkGfm < Formula
  desc "C implementation of GitHub Flavored Markdown"
  homepage "https://github.com/github/cmark-gfm"
  url "https://github.com/github/cmark-gfm/archive/0.29.0.gfm.9.tar.gz"
  version "0.29.0.gfm.9"
  sha256 "07cd91514c29f8d68bcd1bd159661bf92ac060fdb08f6b2e33ce01d3b3000f54"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "f3c9cc39e4ea1d888f6a3f1d08eceef5dc9fb644f3a0c45de854298cbca0f82f"
    sha256 cellar: :any,                 arm64_monterey: "487846c27c1712c74f8160db9d7a5cce293b16c99487608b033cbdf271a17f66"
    sha256 cellar: :any,                 arm64_big_sur:  "eb5488e51d848e1f3c901bea665a29beb51a7cf1855c05d08ae05d0bac1fc2b6"
    sha256 cellar: :any,                 ventura:        "1ffed30515102c6f37973a7177a9033ff332a31bc32a9425f04cd4053d4e4e23"
    sha256 cellar: :any,                 monterey:       "cefc741cc03ee36e53d9cbe9c949801a685c1f9033b2a0050884f8883fe14424"
    sha256 cellar: :any,                 big_sur:        "5156da001a017a5700b47ea1e21ee4dc6d3eb1495d5eb78c440e0e1568749fb3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "893b7ef587c2e4603fa3c25fd664cb04cec5ab3dc2ec4edcc1e6ca7ae3421696"
  end

  depends_on "cmake" => :build
  depends_on "python@3.11" => :build

  conflicts_with "cmark", because: "both install a `cmark.h` header"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args, "-DCMAKE_INSTALL_RPATH=#{rpath}"
      system "make", "install"
    end
  end

  test do
    output = pipe_output("#{bin}/cmark-gfm --extension autolink", "https://brew.sh")
    assert_equal '<p><a href="https://brew.sh">https://brew.sh</a></p>', output.chomp
  end
end
