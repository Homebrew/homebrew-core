class Amber < Formula
  desc "Crystal web framework. Bare metal performance, productivity and happiness"
  homepage "https://amberframework.org/"
  url "https://github.com/amberframework/amber/archive/refs/tags/v1.4.1.tar.gz"
  sha256 "92664a859fb27699855dfa5d87dc9bf2e4a614d3e54844a8344196d2807e775c"
  license "MIT"

  bottle do
    sha256 arm64_ventura:  "9c3ad755b1bd22beae98dbc088df82b80180f04b1d541d3b708c1af29a502c41"
    sha256 arm64_monterey: "c00f64c38a9edbcc84fcba1f7ac17674e5b9d48066e95bc838e31d495ae7035f"
    sha256 arm64_big_sur:  "0474b1b3726aaec6f8ad34e7d7d1fbd7ea6d0ec1bfa627cd213ce5e50468f44d"
    sha256 ventura:        "d529f79e1baff921927446fb6ad72469042e595720531334c164036a73b11c23"
    sha256 monterey:       "584480426c743539cb3f70dfcb55625f6e27977248e2e747366e3dcd547039af"
    sha256 big_sur:        "951253c81419f90acab9fa226d5b5ec4c858e4c6837b78c9490ae085b76fc008"
    sha256 x86_64_linux:   "3f79958bab0aeb33079eaddd9f5481756d1803d55ef861d8f07b632229d4bcfc"
  end

  depends_on "crystal"
  depends_on "openssl@3"
  uses_from_macos "sqlite"

  # patch granite to fix db dependency resolution issue
  # upstream patch https://github.com/amberframework/amber/pull/1339
  patch do
    url "https://github.com/amberframework/amber/commit/20f95cae1d8c934dcd97070daeaec0077b00d599.patch?full_index=1"
    sha256 "ad8a303fe75611583ada10686fee300ab89f3ae37139b50f22eeabef04a48bdf"
  end

  def install
    system "shards", "install"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    output = shell_output("#{bin}/amber new test_app")
    %w[
      config/environments
      amber.yml
      shard.yml
      public
      src/controllers
      src/views
      src/test_app.cr
    ].each do |path|
      assert_match path, output
    end

    cd "test_app" do
      build_app = shell_output("shards build test_app")
      assert_match "Building", build_app
      assert_predicate testpath/"test_app/bin/test_app", :exist?
    end
  end
end
