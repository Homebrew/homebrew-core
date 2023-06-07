class Amber < Formula
  desc "Crystal web framework. Bare metal performance, productivity and happiness"
  homepage "https://amberframework.org/"
  url "https://github.com/amberframework/amber/archive/refs/tags/v1.3.2.tar.gz"
  sha256 "37511d6b4afe308e1943cedeab9114b01d5787d868c23d2c0cc555917a21c830"
  license "MIT"

  bottle do
    sha256 arm64_ventura:  "09874b1c0219b906acb44c2e5e7cc289f7d302fae6c1b6095683535267a07dd0"
    sha256 arm64_monterey: "b3861f5e4f7e94f731cb0de75d03d0e0751db0bff733b6db9e19dcb062f78053"
    sha256 arm64_big_sur:  "3aae57960a61b66b2c6e3383af499e72b24423174ce6b33278785423dbe10f36"
    sha256 ventura:        "78e8fbf9f87122ccb0bfa93abdf3a1d6c54bc1486a0774a5eb2ca68088479b36"
    sha256 monterey:       "f162565aaf09c4cec2a72da13d37237d0e2a854eb8f463e4a96de0251f192dbd"
    sha256 big_sur:        "bcefbabba33b53d726ac043cf74798c1dddbc0d5df8bbdf05acec1632853abd7"
    sha256 x86_64_linux:   "0c15fd19b2005974609aeef0cfd6fffbb3ed1337bc4af58b3f4e59cca7bb4710"
  end

  depends_on "crystal"
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
