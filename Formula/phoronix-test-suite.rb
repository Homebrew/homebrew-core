class PhoronixTestSuite < Formula
  desc "Open-source automated testing/benchmarking software."
  homepage "https://www.phoronix-test-suite.com/"
  url "https://github.com/phoronix-test-suite/phoronix-test-suite/archive/v7.4.0.tar.gz"
  sha256 "beb0875ca74b62a5bb0768c337baceb3415817a6ef487dd14289ab2d84b6c504"

  bottle do
    cellar :any_skip_relocation
    sha256 "9ffc35ffe7794b546806b5554a228296f495a398239636cf32a2eeace9c48eee" => :high_sierra
    sha256 "a0342ec359f6be0bbfec1918f6e58684d66ef7fb05ed35e0f25bad527475fd30" => :sierra
    sha256 "152a7ddddb515433d728f7d969c895da9b4c464518550d0ea6ba20755ea8f8c3" => :el_capitan
    sha256 "152a7ddddb515433d728f7d969c895da9b4c464518550d0ea6ba20755ea8f8c3" => :yosemite
  end

  def install
    system "./install-sh", prefix
    bash_completion.install "./pts-core/static/bash_completion"
  end

  test do
    assert_match "Trysil", shell_output("#{bin}/phoronix-test-suite version | grep -v ^$")
  end
end
