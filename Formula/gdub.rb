class Gdub < Formula
  desc "Gradlew/gradle wrapper"
  homepage "https://www.gdub.rocks/"
  url "https://github.com/dougborg/gdub/archive/v0.2.0.tar.gz"
  sha256 "aa3da76752b597e60094a67971f35dfe20377390d21b3ae3b45b7b7040e9a268"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "b2381d533ecbab2d5c7e984f2b8a59601a1a50c0fd16de0942de59613f423a3e"
  end

  # "This project is obsolete. Please use 'gng' instead.":
  # https://github.com/gdubw/gng
  deprecate! date: "2021-01-05", because: :repo_archived

  def install
    bin.install "bin/gw"
  end

  test do
    assert_match "No gradlew set up for this project", pipe_output("#{bin}/gw 2>&1")
  end
end
