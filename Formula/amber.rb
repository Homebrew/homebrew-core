class Amber < Formula
  desc "Crystal web framework. Bare metal performance, productivity and happiness"
  homepage "https://amberframework.org/"
  url "https://github.com/amberframework/amber/archive/refs/tags/v1.3.2.tar.gz"
  sha256 "37511d6b4afe308e1943cedeab9114b01d5787d868c23d2c0cc555917a21c830"
  license "MIT"
  revision 1

  bottle do
    sha256 arm64_ventura:  "a58e71da8f3bd81d7ea0865629192516c7b78ffdf86f4a36ef9d16f0989f4d53"
    sha256 arm64_monterey: "242d9eae3535ff3923abc04f150293a831629401b2c5137814c4314254d524ee"
    sha256 arm64_big_sur:  "89d5c6078a78519c8448d69e3dae8fa566b2cb2cdf9072ebcb2f3b26620d567d"
    sha256 ventura:        "e20092fc8b6a737600755e31f6d10c1235411d0ba8a82b3c9ffbb9817c5170ca"
    sha256 monterey:       "58f0ea20927b9e0a637f86b1cc27af7d3fe3967ce1eb4b4dc58ea1673035ea0c"
    sha256 big_sur:        "da3c927123d4b58560c201a213411030ec071b11f0a287f8a0542e801d0770a6"
    sha256 x86_64_linux:   "564fadf54bc255a81862b1c60fe76ffe611b5ef8eebc452a1e3e12e169a8d44a"
  end

  depends_on "crystal"
  depends_on "openssl@3"
  uses_from_macos "sqlite"

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
      src/assets
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
