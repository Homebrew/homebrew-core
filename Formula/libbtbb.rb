class Libbtbb < Formula
  include Language::Python::Shebang

  desc "Bluetooth baseband decoding library"
  homepage "https://github.com/greatscottgadgets/libbtbb"
  url "https://github.com/greatscottgadgets/libbtbb/archive/2020-12-R1.tar.gz"
  version "2020-12-R1"
  sha256 "9478bb51a38222921b5b1d7accce86acd98ed37dbccb068b38d60efa64c5231f"
  license "GPL-2.0-or-later"
  revision 1
  head "https://github.com/greatscottgadgets/libbtbb.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "2904d63b321c2a3b6810b42f9d8bbf865925a757b7248a4d9466ebcca87d21ed"
    sha256 cellar: :any,                 arm64_big_sur:  "fe9f1a04a88665e9be1e82b96bf38fcf29734f7f4989a78a924c2c1ca710f26b"
    sha256 cellar: :any,                 monterey:       "338757b7693248b93fba7d0e47534d7927ccc0cf9fb66d4c1d2b914205d13389"
    sha256 cellar: :any,                 big_sur:        "46b4667061bf40d6c0416eb7f1f132883a8ea070097ad5fa4f1a9da6c54b25cc"
    sha256 cellar: :any,                 catalina:       "3efe27e4f6d3b39e53a23c1be7fabd0edf7eca5f3ce3c29a1cbba6ccd7d0df41"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b21af3849528f1de05897c38033ca05ecaf0ab075a517e5b94727e66385e24ae"
  end

  depends_on "cmake" => :build
  depends_on "python@3.10"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
    rewrite_shebang detected_python_shebang, bin/"btaptap"
  end

  test do
    system bin/"btaptap", "-r", test_fixtures("test.pcap")
  end
end
