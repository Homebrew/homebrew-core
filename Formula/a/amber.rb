class Amber < Formula
  desc "Crystal web framework. Bare metal performance, productivity and happiness"
  homepage "https://amberframework.org/"
  url "https://github.com/amberframework/amber/archive/refs/tags/v1.4.1.tar.gz"
  sha256 "92664a859fb27699855dfa5d87dc9bf2e4a614d3e54844a8344196d2807e775c"
  license "MIT"
  revision 2

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "3f029e40ff7e31d3768f46e99580bce3b3c7d1b509deaa7812dd3da9cdb624b1"
    sha256 arm64_sequoia: "b41377d50fd655c9bd41f3a894c57e6662fb55189b4b410f6be681bfd0038ab6"
    sha256 arm64_sonoma:  "9cee3079e0c86fd4db11501fe0ebb08a686e8fa8d8aaada670ae0b83f73ecbd7"
    sha256 sonoma:        "41d3124e51cd3918c92660744aa2a3a8432c9f8a89d553aa8e30517f36c0ea06"
    sha256 arm64_linux:   "c5a94b2181e3729c44668843bb97e9a51b6372eb991511a7dbde980e08c42c08"
    sha256 x86_64_linux:  "c8379f58651cf3bf1ecf4489e40c9232367e9827a7657b27ceb341f7547d40d9"
  end

  depends_on "bdw-gc"
  depends_on "crystal"
  depends_on "libevent"
  depends_on "libyaml"
  depends_on "openssl@3"
  depends_on "pcre2"
  depends_on "sqlite"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  # patch granite to fix db dependency resolution issue
  # upstream patch https://github.com/amberframework/amber/pull/1339
  patch do
    url "https://github.com/amberframework/amber/commit/54b1de90cd3e395cd09326b1d43074e267c79695.patch?full_index=1"
    sha256 "be0e30f08b8f7fcb71604eb01136d82d48b7e34afac9a1c846c74a7a7d2f8bd6"
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
      assert_match "Building", shell_output("#{Formula["crystal"].bin}/shards build test_app")
    end
    assert_path_exists testpath/"test_app/bin/test_app"
  end
end
