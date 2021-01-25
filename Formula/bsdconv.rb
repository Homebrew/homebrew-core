class Bsdconv < Formula
  desc "Charset/encoding converter library"
  homepage "https://github.com/buganini/bsdconv"
  url "https://github.com/buganini/bsdconv/archive/11.6.tar.gz"
  sha256 "e856e24474deb3731ac059a96af0078ba951895f2cb3b31f125148a29cc32b70"
  license "BSD-2-Clause"
  head "https://github.com/buganini/bsdconv.git"

  bottle do
    sha256 "18fa8aff61b229d34b05516953d49aa807edb4f2231108e84bbe5c4847aac9e0" => :big_sur
    sha256 "92a2e9b7e7389c00556c577f05e2e7d6ff39919d62153fb07dd98df8ba6347ab" => :arm64_big_sur
    sha256 "c7c3ee826009c6a77d2e435b56deee58b3243e7dc2ac54a7ddea90555a16ef7a" => :catalina
    sha256 "8ae3048037104e7a91ffd76ff6ef1910c8252d050e98b03e4083841525d19a0c" => :mojave
  end

  def install
    system "make", "PREFIX=#{prefix}"
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    output = pipe_output("#{bin}/bsdconv BIG5:UTF-8", "\263\134\273\134")
    output.force_encoding("UTF-8") if output.respond_to?(:force_encoding)
    assert_equal "許蓋", output
  end
end
