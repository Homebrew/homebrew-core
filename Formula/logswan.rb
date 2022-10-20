class Logswan < Formula
  desc "Fast Web log analyzer using probabilistic data structures"
  homepage "https://www.logswan.org"
  url "https://github.com/fcambus/logswan/archive/2.1.13.tar.gz"
  sha256 "6ddc406121e17f3fd21907d77d020466bb4584c3855701579d40265fdb315d02"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "704b6884e6e30085a75e50c24e0f2a89a0ea28a52525677e1cc2740d7d31253d"
    sha256 cellar: :any,                 arm64_big_sur:  "bf75c8a03359eccb1d7c9dd8b71d38a8793b15fc28f6ba779e81c18b9bbf0ccf"
    sha256 cellar: :any,                 monterey:       "388af42a86df0ba7b2ab0c999354d9e939a674c56badbfa77a5a19f4b49ab552"
    sha256 cellar: :any,                 big_sur:        "a1d3f583a9a0a7637f452572c5f2cabe31b1c28783b01a57deb744b2efe5b9fc"
    sha256 cellar: :any,                 catalina:       "32555f1536d5a46c88f19817089976430dae4bdd337861f504472ddff6d6f19a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1bf32c5b8d7ccb731750838d6481f2d8eb7004870f6800558c6fcecd08414a9b"
  end

  depends_on "cmake" => :build
  depends_on "jansson"
  depends_on "libmaxminddb"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make"
      system "make", "install"
    end
    pkgshare.install "examples"
  end

  test do
    assert_match "visits", shell_output("#{bin}/logswan #{pkgshare}/examples/logswan.log")
  end
end
