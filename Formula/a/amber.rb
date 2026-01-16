class Amber < Formula
  desc "Crystal web framework. Bare metal performance, productivity and happiness"
  homepage "https://amberframework.org/"
  url "https://github.com/amberframework/amber/archive/refs/tags/v1.4.1.tar.gz"
  sha256 "92664a859fb27699855dfa5d87dc9bf2e4a614d3e54844a8344196d2807e775c"
  license "MIT"
  revision 2

  bottle do
    sha256 arm64_tahoe:   "aab42dadcba980b950797c53d051d76831f90e4457d6f70aa18553d4f67e4e6e"
    sha256 arm64_sequoia: "c8bb8c22fe777f8058380a9193fa2128127a80e5b4e5a695fdd5b3684db1cbc0"
    sha256 arm64_sonoma:  "aedf640540270738aa662506e1a34e9853c4c7474310b2b7a5d4dc86d6c3a5c9"
    sha256 arm64_ventura: "b48cb05e8b797ee829115cc6c60e89172169a0f68c4122fa8f9aaa07be7df8d0"
    sha256 sonoma:        "d5632dc63a99120dcd4715a94f58d12dc9ea1ff69914bc6202c7fd0809bdcb29"
    sha256 ventura:       "430d7db186ae038f2d9b5da2f1f96e1f32f3dcfeb5139fc94c1a5d7da705b48b"
    sha256 arm64_linux:   "26750133b64027b387c8c10e9176f1f55885b6ec2dc1f12ccd3337b6d9870db6"
    sha256 x86_64_linux:  "459d2c3de122b8f9f0890270fd3b638180521f96976572ef59f31c5a8712bf65"
  end

  depends_on "bdw-gc"
  depends_on "crystal"
  depends_on "libevent"
  depends_on "libyaml"
  depends_on "openssl@3"
  depends_on "pcre2"
  depends_on "sqlite"

  uses_from_macos "zlib"

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
