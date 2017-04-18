class BatsSupport < Formula
  desc "Supporting library for Bats test helpers"
  homepage "https://github.com/ztombol/bats-support"
  url "https://github.com/ztombol/bats-support/archive/v0.2.0.tar.gz"
  sha256 "9bfa93d2db046e375e31e4c6cbbe834b015c695862c2dca1b46b71401de1038d"
  depends_on "bats"

  def install
    mkdir "bats-support"
    mv "load.bash", "bats-support/"
    mv "src", "bats-support/"
    mv "test", "bats-support/"
    lib.install "bats-support"
    ohai "Use `load '/usr/local/lib/bats-support/load'` in your bats test to load this library."
  end

  test do
    system "bats", "#{lib}/bats-support/test"
  end
end
