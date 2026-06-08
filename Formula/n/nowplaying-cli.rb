class NowplayingCli < Formula
  desc "Retrieves currently playing media, and simulates media actions"
  homepage "https://github.com/kirtan-shah/nowplaying-cli"
  url "https://github.com/kirtan-shah/nowplaying-cli/archive/refs/tags/v2.1.0.tar.gz"
  sha256 "c7c23564657bf5b5598bdf58f79e11c8dffbde909e364df4da7c3a49a26e3753"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "600fb00263c9e681254f24f85b53ce6115685b277dad95388eaedcd72d23e015"
    sha256 cellar: :any, arm64_sequoia: "79caf948bf5f319c89aa58297b6e9af714e08ec7abf621c262cf141f287eb518"
    sha256 cellar: :any, arm64_sonoma:  "4af22862856403429542dde32839d07e74aa046e2cdb340253c1959da0d620ad"
    sha256 cellar: :any, sonoma:        "3ac15d66faea03a58864b93aacf850ebcdbf49196157dfd789fc81bacf73e02c"
  end

  depends_on :macos

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    assert_match "{", shell_output("#{bin}/nowplaying-cli get-raw")
  end
end
