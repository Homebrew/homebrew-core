class CrystalIcr < Formula
  desc "Interactive console for Crystal programming language"
  homepage "https://github.com/crystal-community/icr"
  url "https://github.com/crystal-community/icr/archive/v0.3.0.tar.gz"
  sha256 "4e3695965c95d55d345baf8c7fc9a7eff0bf95da1b1c8141bdb63c2d5269a30e"

  bottle do
    sha256 "e7e329d7ddf2e5fd09c62e0df8d027d51bb926db14af813a720898688b9a0ae6" => :high_sierra
    sha256 "951ce7170516e7b5b5adc4b64f52b4053ad36ce581e2dbc43843f0e07ea2eedf" => :sierra
    sha256 "b6677ec4428770723ebee3a5059eee7a5a9a37b01943e09cce0654f7f6c58bac" => :el_capitan
    sha256 "bc7b3b94b127632b60dd14127749d16ef92ba97520163226e1a0ccf0910a5579" => :yosemite
  end

  depends_on "crystal-lang"
  depends_on "readline"

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    assert_match "icr version #{version}", shell_output("#{bin}/icr -v")
  end
end
