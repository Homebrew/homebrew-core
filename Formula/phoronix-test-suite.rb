class PhoronixTestSuite < Formula
  desc "Open-source automated testing/benchmarking software"
  homepage "https://www.phoronix-test-suite.com/"
  url "https://github.com/phoronix-test-suite/phoronix-test-suite/archive/v8.0.1.tar.gz"
  sha256 "8bfe972c601884f2bbbf4d5069c7691637e8a30af55d2a9597dbe53911b49081"

  head "https://github.com/phoronix-test-suite/phoronix-test-suite.git"

  devel do
    url "https://github.com/phoronix-test-suite/phoronix-test-suite/archive/v8.2.0m1.tar.gz"
    sha256 "06bcf17f3812799d3acaa7a90f4da9ddc148db3f9c438acf1df4069cfe2013a5"
    version "8.2.0m1"
  end

  bottle :unneeded

  def install
    ENV["DESTDIR"] = buildpath/"dest"
    system "./install-sh", prefix
    prefix.install (buildpath/"dest/#{prefix}").children
    bash_completion.install "dest/#{prefix}/../etc/bash_completion.d/phoronix-test-suite"
  end

  # 7.4.0 installed files in the formula's rack so clean up the mess.
  def post_install
    rm_rf [prefix/"../etc", prefix/"../usr"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/phoronix-test-suite version")
  end
end
