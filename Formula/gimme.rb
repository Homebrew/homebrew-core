class Gimme < Formula
  desc "Shell script to install any Go version"
  homepage "https://github.com/travis-ci/gimme"
  url "https://github.com/travis-ci/gimme/archive/v1.1.0.tar.gz"
  sha256 "9f6016a00198b66fc9ea529d0cb768acef2fe9db4b18675c613aa440161612a1"

  bottle :unneeded

  def install
    bin.install "gimme"
  end

  test do
    system "#{bin}/gimme", "-l"
  end
end
