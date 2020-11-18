class PhoronixTestSuite < Formula
  desc "Open-source automated testing/benchmarking software"
  homepage "https://www.phoronix-test-suite.com/"
  url "https://github.com/phoronix-test-suite/phoronix-test-suite/archive/v10.0.1.tar.gz"
  sha256 "3d65dc03c0e20e2419521157cb8189b90e93826dfbf81e7e4d088bc2f14b0650"
  license "GPL-3.0-or-later"
  head "https://github.com/phoronix-test-suite/phoronix-test-suite.git"

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
    cd pkgshare
    assert_match version.to_s, shell_output("#{bin}/phoronix-test-suite version")
  end
end
