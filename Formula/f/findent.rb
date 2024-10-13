class Findent < Formula
  desc "Indent and beautify Fortran sources and generate dependency information"
  homepage "https://www.ratrabbit.nl/ratrabbit/findent/index.html"
  url "https://downloads.sourceforge.net/project/findent/findent-4.3.3.tar.gz"
  sha256 "cd91293a44144806e16fbfc677768cc5102cd20dfc92a7b9d242b639d856a16f"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(%r{url=.*?/findent[._-]v?(\d+(?:\.\d+)+)\.(?:t|zip)}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "dc58685ac19b12f19c514b236cf1f6aa742f26985242441549443f929c26da01"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "811dbae48046410d7190b334697373e2b4cce6c5735edf68454ae83bbf020ce8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9f869ace2c812eaa5dd944a363853bb7c925ce4a45d69a478b257b8f14e634d7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f7408059c20283084436de3228505c5e6ae38a647ee1b05ed2a1b6cc77fe9c61"
    sha256 cellar: :any_skip_relocation, sonoma:         "9c72cc218415dd6ef7c1eabd8d6d8eb999343c378ec7c6dd0cf5afab29c22d05"
    sha256 cellar: :any_skip_relocation, ventura:        "243f9a41ae40641221ab2501aeec5ea73fe6a305b4d3509affefe314a848b72f"
    sha256 cellar: :any_skip_relocation, monterey:       "64d4060095748ea621fdd52eae73c887d1591a460b890e52ed3b618dccaee82e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "44a1715537c947b585f778230f26ae8fa51785d449d82436dfa18ba05bc2906b"
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
    assert_predicate testpath/"progfree.f.out.f90", :exist?
    assert compare_file(testpath/"progfree.f.try.f.ref", testpath/"progfree.f.out.f90")
  end
end
