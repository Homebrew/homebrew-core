class Openvi < Formula
  desc "Portable OpenBSD vi for UNIX systems"
  homepage "https://github.com/johnsonjh/OpenVi"
  url "https://github.com/johnsonjh/OpenVi/archive/refs/tags/7.6.30.tar.gz"
  sha256 "1ac5487280deca5fe539d5b6302bfbc95a9eb52aa2e3807d30f5dd82f0bdb355"
  license "BSD-3-Clause"
  head "https://github.com/johnsonjh/OpenVi.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "b56e110ee526110cfe6d9c9dc19a57f4e5401a118c5cde52e2ea00f4f0419485"
    sha256 cellar: :any,                 arm64_sonoma:  "b38ecab7e5362c9ad08559587bc97a019091a9f03e15d6d81194fd989141acbb"
    sha256 cellar: :any,                 arm64_ventura: "92a0cdacbf81700bab889708621afe2a1c1b3ff4612f824c158082e7870fe49d"
    sha256 cellar: :any,                 sonoma:        "de6b931ab2119f6079236b062065a183b403512bc38cf3962b374251fd8d528a"
    sha256 cellar: :any,                 ventura:       "24c93899248d3649b6662660bcb6b0fcd5e61c837a9d1b5f4f2265f7bf2b0101"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b7b1c4a7d6ca50ec388ed1355d4d83fbd175c73bb1947cb2d97c036db007ba53"
  end

  depends_on "ncurses" # https://github.com/johnsonjh/OpenVi/issues/32

  def install
    system "make", "install", "CHOWN=true", "LTO=1", "PREFIX=#{prefix}"
  end

  test do
    (testpath/"test").write("This is toto!\n")
    pipe_output("#{bin}/ovi -e test", "%s/toto/tutu/g\nwq\n")
    assert_equal "This is tutu!\n", File.read("test")
  end
end
