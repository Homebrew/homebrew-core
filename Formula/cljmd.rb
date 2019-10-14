class Cljmd < Formula
  desc "Clojure for Automation Scripting and CLI Tools"
  homepage "https://github.com/axrs/cljmd"
  url "https://github.com/axrs/cljmd/archive/v0.0.4.tar.gz"
  sha256 "27dad0df4ff240c2edf6a85424ba395b941996e6d728dc2d12ad7d7e00cb657a"

  depends_on "clojure"

  def install
    bin.install "cljmd"
  end
end
