class PhoronixTestSuite < Formula
  desc "Open-source automated testing/benchmarking software"
  homepage "https://www.phoronix-test-suite.com/"
  url "https://github.com/phoronix-test-suite/phoronix-test-suite/archive/v9.0.1.tar.gz"
  sha256 "66f57eeb12241966cb7ad6594981bfd6ccdb28c4a14325271bec50c810d041db"
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
    assert_match version.to_s, shell_output("#{bin}/phoronix-test-suite version")
  end
end
