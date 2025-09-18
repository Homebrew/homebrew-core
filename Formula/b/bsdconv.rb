class Bsdconv < Formula
  desc "Charset/encoding converter library"
  homepage "https://github.com/buganini/bsdconv"
  url "https://github.com/buganini/bsdconv/archive/refs/tags/11.6.tar.gz"
  sha256 "e856e24474deb3731ac059a96af0078ba951895f2cb3b31f125148a29cc32b70"
  license "BSD-2-Clause"
  head "https://github.com/buganini/bsdconv.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 arm64_tahoe:    "4975475d7d550693334c6abef8a0c8c1ee3f87552e3310f333f6a7e3b1548240"
    sha256 arm64_sequoia:  "eb27911fad713a1d8d36146105cb0abffcf7a6c78bdd358c09e5ff64c207e3fd"
    sha256 arm64_sonoma:   "d5f2086f8915426931817985ce3a3b379b4cac7ba2c31ea1b8ba69f46a51ebb2"
    sha256 arm64_ventura:  "3677f1c3ddd940126cdbaef44ea54ee40e8912572886d490e75139dd1950e268"
    sha256 arm64_monterey: "bc26b770aa6622c467bb6adb345593c59cee51d1071211dd5acc913b4f0932c8"
    sha256 arm64_big_sur:  "92a2e9b7e7389c00556c577f05e2e7d6ff39919d62153fb07dd98df8ba6347ab"
    sha256 sonoma:         "6577f7dfca8ee141a9817219d6305b3f983ffeb11e2da5a3ab49d1834286356a"
    sha256 ventura:        "1021dc605aa738c62277f0c5eee99044daeb20111ce08360b827395fd088f779"
    sha256 monterey:       "1e695c9018c174f1dc39d4205e26a507acd12f789733c5c76608f5ceef92a2b4"
    sha256 big_sur:        "18fa8aff61b229d34b05516953d49aa807edb4f2231108e84bbe5c4847aac9e0"
    sha256 catalina:       "c7c3ee826009c6a77d2e435b56deee58b3243e7dc2ac54a7ddea90555a16ef7a"
    sha256 arm64_linux:    "2be08396cd20f1a195b1f1322e48fb636b76ab7d484c28790578286dcbaf011d"
    sha256 x86_64_linux:   "a77ffb5b4b404f82c6dcaa52eb3f63e23931e93782a3b179e873f47628673213"
  end

  def install
    system "make", "PREFIX=#{prefix}"
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    output = pipe_output("#{bin}/bsdconv BIG5:UTF-8", "\263\134\273\134", 0)
    output.force_encoding("UTF-8") if output.respond_to?(:force_encoding)
    assert_equal "許蓋", output
  end
end
