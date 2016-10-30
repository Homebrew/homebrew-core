class Gdub < Formula
  desc "Gradlew/gradle wrapper."
  homepage "http://www.gdub.rocks"
  url "https://github.com/dougborg/gdub/archive/v0.1.0.tar.gz"
  sha256 "ddf2572cc67b8df3293b1707720c6ef09d6caf73227fa869a73b16239df959c3"

  bottle :unneeded

  def install
    bin.install "bin/gw"
  end

  test do
    assert_match "No gradlew set up for this project", pipe_output("#{bin}/gw 2>&1")
  end
end
