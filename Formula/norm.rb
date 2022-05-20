class Norm < Formula
  desc "NACK-Oriented Reliable Multicast"
  homepage "https://www.nrl.navy.mil/itd/ncs/products/norm"
  url "https://github.com/USNavalResearchLaboratory/norm/releases/download/v1.5.9/src-norm-1.5.9.tgz"
  sha256 "ef6d7bbb7b278584e057acefe3bc764d30122e83fa41d41d8211e39f25b6e3fa"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "6db456e4648b7f8baec7a2d6af342594aa89cec71c375e5a6c5d7be34c4c3e62"
    sha256 cellar: :any,                 arm64_big_sur:  "ba0f0331fe8419a2f9d34f0a89378c9ea351afd9d2f8efd140df2cf1830000a3"
    sha256 cellar: :any,                 monterey:       "7d0f0fbc73e3ed79afad76ca563aa97532a7cee2c72f7c954ad0841c5407dc9a"
    sha256 cellar: :any,                 big_sur:        "a1eff7c9b5a50e5524d5dddd7cd025e0f2392585f4f74b7dca1b71b29a72972e"
    sha256 cellar: :any,                 catalina:       "58429af961d437979c286290c42508079f238e17cce066184944e0a404c0e829"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e73b7067d42e7b1b3efaa2f19698a1f409b2a55a5719b56f41ddf5249913e6c3"
  end

  depends_on "python@3.10" => :build

  # Fix warning: 'visibility' attribute ignored [-Wignored-attributes]
  # Remove in the next release
  #
  # Ref https://github.com/USNavalResearchLaboratory/norm/pull/27
  patch do
    url "https://github.com/USNavalResearchLaboratory/norm/commit/476b8bb7eba5a9ad02e094de4dce05a06584f5a0.patch?full_index=1"
    sha256 "08f7cc7002dc1afe6834ec60d4fea5c591f88902d1e76c8c32854a732072ea56"
  end

  def install
    system "python3", "./waf", "configure", "--prefix=#{prefix}"
    system "python3", "./waf", "install"

    include.install "include/normApi.h"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <assert.h>
      #include <normApi.h>

      int main()
      {
        NormInstanceHandle i;
        i = NormCreateInstance(false);
        assert(i != NORM_INSTANCE_INVALID);
        NormDestroyInstance(i);
        return 0;
      }
    EOS
    system ENV.cxx, "test.c", "-L#{lib}", "-lnorm", "-o", "test"
    system "./test"
  end
end
