class Findent < Formula
  desc "Indent and beautify Fortran sources and generate dependency information"
  homepage "https://www.ratrabbit.nl/ratrabbit/findent/index.html"
  url "https://downloads.sourceforge.net/project/findent/findent-4.3.2.tar.gz"
  sha256 "62144eb84bda93d21241a6963ef973f92778bca7c915bfea9b38973774e85c7e"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(%r{url=.*?/findent[._-]v?(\d+(?:\.\d+)+)\.(?:t|zip)}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "51d3f04516a5dca7b02ea5ef859098b4639dd7a1df2875f3a0da7f3887cc94fd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "16e0b56062b32d468ba4c30afa5b0b26d2501e089c2ec763fc5482b905458d94"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "edf41342fafcd0e95abcbbbf2a26118bf2f3fbca7d359afd64daa3d4a762d32e"
    sha256 cellar: :any_skip_relocation, sonoma:         "fd9ce5c7feac6ace54ea379732628ecb5c1f6065340d7fe7e73d37bfa1524e8d"
    sha256 cellar: :any_skip_relocation, ventura:        "546082a8be71fe836482bff9e4ff70089c57c08943c9322ecd2953baae861a87"
    sha256 cellar: :any_skip_relocation, monterey:       "2404f50565658c7011a3cbb80b35333765760842f59f8be624dc57a88fc571b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "15ba3564c4148a083e83724d77f81bc62c19fa4554602e3d2c31dd47a95ef6a3"
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
    system "#{bin}/findent #{flags} < progfree.f.in > progfree.f.out.f90"
    assert_predicate testpath/"progfree.f.out.f90", :exist?
    assert compare_file(testpath/"progfree.f.try.f.ref", testpath/"progfree.f.out.f90")
  end
end
