class Amber < Formula
  desc "Crystal web framework. Bare metal performance, productivity and happiness"
  homepage "https://amberframework.org/"
  url "https://github.com/amberframework/amber/archive/refs/tags/v1.4.1.tar.gz"
  sha256 "92664a859fb27699855dfa5d87dc9bf2e4a614d3e54844a8344196d2807e775c"
  license "MIT"
  revision 1

  bottle do
    sha256 arm64_sonoma:   "01684ca0081c2ec3f8f7b79ca8411a80b6946106a200d07d9caf5a5e88537a2c"
    sha256 arm64_ventura:  "093f9c6482e12c09afe8baafa7ab0ecc3f92195e0f9f793332600c81b6f00e4a"
    sha256 arm64_monterey: "b5d4b6fa3122283f3232e60d39c5757a6943ea7b0b7ee4b87b19cf6982af58ff"
    sha256 sonoma:         "9dd6705f3a6026eeb9f7421d0267375de14a658f624c32e38b78a5a7e374da2b"
    sha256 ventura:        "259b0a5803e82a4acb864132af49aea3d231db158eab8dbd757ae5ebc41501eb"
    sha256 monterey:       "5ba15bca8f1d9ab0a7230426e95168ac7f460ff97b2d0fd0e63b53a33b82c8fa"
    sha256 x86_64_linux:   "0d426231e65332308d6b8bb925c8d0b08ed187fa360dd808615b3048b1c531e6"
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
