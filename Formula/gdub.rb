class Gdub < Formula
  desc "Gradlew/gradle wrapper"
  homepage "https://www.gdub.rocks/"
  url "https://github.com/dougborg/gdub/archive/v0.2.0.tar.gz"
  sha256 "aa3da76752b597e60094a67971f35dfe20377390d21b3ae3b45b7b7040e9a268"

  bottle :unneeded

  def install
    bin.install "bin/gw"
  end

  test do
    assert_match "No gradlew set up for this project", pipe_output("#{bin}/gw 2>&1")
  end
end
