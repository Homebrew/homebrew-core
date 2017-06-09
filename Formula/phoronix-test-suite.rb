class PhoronixTestSuite < Formula
  desc "Open-source automated testing/benchmarking software."
  homepage "https://www.phoronix-test-suite.com/"
  url "https://github.com/phoronix-test-suite/phoronix-test-suite/archive/v7.2.0.tar.gz"
  sha256 "20bdab1e979636476ebbfc003cbbbd36a04cc35acef825ff0d11a0b3a33a2474"

  bottle do
    cellar :any_skip_relocation
    sha256 "c29c9748f6ba2c76c20a0dedbc96b72d0dc4ccd243506d5752c1f9e42964aece" => :sierra
    sha256 "128720345d82750d788cf4c50d0865d5922041018315633233266cffd6693f02" => :el_capitan
    sha256 "128720345d82750d788cf4c50d0865d5922041018315633233266cffd6693f02" => :yosemite
  end

  def install
    system "./install-sh", prefix
    bash_completion.install "./pts-core/static/bash_completion"
  end

  test do
    assert_match "Trysil", shell_output("#{bin}/phoronix-test-suite version | grep -v ^$")
  end
end
