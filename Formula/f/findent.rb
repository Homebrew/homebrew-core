class Findent < Formula
  desc "Indent and beautify Fortran sources and generate dependency information"
  homepage "https://www.ratrabbit.nl/ratrabbit/findent/index.html"
  url "https://downloads.sourceforge.net/project/findent/findent-4.3.7.tar.gz"
  mirror "https://www.ratrabbit.nl/downloads/findent/findent-4.3.7.tar.gz"
  sha256 "e2da8b8c0c1961b2bc9dce4c6caa79cad09245d36388bea1fc02c4ec1fd8b998"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(%r{url=.*?/findent[._-]v?(\d+(?:\.\d+)+)\.(?:t|zip)}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b53bf06826f82f9d100c497b38bda4a417fd9c2fd55e9d49756b0cfb571f31b9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "53f23e0a9769be9eef0c102b9c9da50c25999f06ca355314775a338549c66c5a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b743bf9cf374a09e433d029fbfdcc82484586a94162a2fcaaf804e3988eb2563"
    sha256 cellar: :any_skip_relocation, sonoma:        "082aa9da389d6dbf126f6199bea9a4042a6a55a102c45417da9d1e75272ce70f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "be1463f7231258226a921b3dd68ae95b6ddba38d3ff4e423b7fd83f0117c51bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "168e8c669289dca4ef86b934253345d80b2ea8652b653bdeddb486dc2bd568c6"
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
    (pkgshare/"test").install %w[test/progfree.f.in test/progfree.f.try.f.ref]
  end

  test do
    cp_r pkgshare/"test/progfree.f.in", testpath
    cp_r pkgshare/"test/progfree.f.try.f.ref", testpath

    flags = File.open(testpath/"progfree.f.in", &:readline).sub(/ *! */, "").chomp
    system bin/"findent #{flags} < progfree.f.in > progfree.f.out.f90"
    assert_path_exists testpath/"progfree.f.out.f90"
    assert compare_file(testpath/"progfree.f.try.f.ref", testpath/"progfree.f.out.f90")
  end
end
