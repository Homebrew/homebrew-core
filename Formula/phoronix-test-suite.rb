class PhoronixTestSuite < Formula
  desc "Open-source automated testing/benchmarking software"
  homepage "https://www.phoronix-test-suite.com/"
  url "https://github.com/phoronix-test-suite/phoronix-test-suite/archive/v10.4.0.tar.gz"
  sha256 "4feda834008c9844bbe675a6ce9b88a44d36965bc2d0a9d62c1407ba5b084935"
  license "GPL-3.0-or-later"
  head "https://github.com/phoronix-test-suite/phoronix-test-suite.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

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
