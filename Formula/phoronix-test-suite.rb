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

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "e6ef9090b342a82df1e6127d2b77e3a7cef93c943f469a7a0e7ea4a63b1d6ff4"
    sha256 cellar: :any_skip_relocation, big_sur:       "021e080cf334bf2a07774987010e2ea1047e81348f4b020069c4c016522947de"
    sha256 cellar: :any_skip_relocation, catalina:      "021e080cf334bf2a07774987010e2ea1047e81348f4b020069c4c016522947de"
    sha256 cellar: :any_skip_relocation, mojave:        "021e080cf334bf2a07774987010e2ea1047e81348f4b020069c4c016522947de"
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
