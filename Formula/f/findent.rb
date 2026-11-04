class Findent < Formula
  desc "Indent and beautify Fortran sources and generate dependency information"
  homepage "https://www.ratrabbit.nl/ratrabbit/findent/index.html"
  url "https://downloads.sourceforge.net/project/findent/findent-4.4.3.tar.gz"
  mirror "https://www.ratrabbit.nl/downloads/findent/findent-4.4.3.tar.gz"
  sha256 "37d86de682543ba5655c03907c2888c2d66f29a0699dd0d951f7d327b4678d28"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(%r{url=.*?/findent[._-]v?(\d+(?:\.\d+)+)\.(?:t|zip)}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e726560a0e5055f796ea549a6ca1d3f94b70aff4006ee7207f80b6906fbff521"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "6e714cda7b64adfb3ba99668d9749724fae190016a5b4e995e33b02d6da58123"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "cfd0f403a4e6b1ae42319f3911d51c7e027e223ec23078ebcddeff057f000034"
    sha256 cellar: :any,                 arm64_linux:       "b458709775d092fa44f40bf40568071580fa5b62a77521ea5db0c4be3d20ec54"
    sha256 cellar: :any,                 x86_64_linux:      "1a327150d14249db9db9d2c526b986f426d90244c82cb8a0bf1176f502bd7d5b"
  end

  deny_network_access!

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
