class Amber < Formula
  desc "Crystal web framework. Bare metal performance, productivity and happiness"
  homepage "https://amberframework.org/"
  url "https://github.com/amberframework/amber/archive/refs/tags/v1.5.0.tar.gz"
  sha256 "12c7b576a5f2e0dba53962ca23d18435526a2b685924783d57cb0d507bd93a03"
  license "MIT"

  bottle do
    sha256 arm64_tahoe:   "6e720185a4c012a566b4399e728cbd43553a6eb27541c48c77b8552b8e98e37b"
    sha256 arm64_sequoia: "5ed58ee7e3f2883971712b2cf058e8717a13dcf00a40bbb5ce74a3d75f6896df"
    sha256 arm64_sonoma:  "07294ec9c0106cf3efc94f91f0cdccdae25288cdcb05627785f4fba5d41d5720"
    sha256 sonoma:        "03a76a11085d2a54a377f4c0980e5c94e6dedb58377a1ff63dbdab005c4876d6"
    sha256 arm64_linux:   "65fb21b950336bf46af9f6edd3255ee2adc62448c572911fb7cb429efa80c0e6"
    sha256 x86_64_linux:  "de9d850afa9b038d4ccfe909feb126f6e1ca950ec454232a31f052696518ccee"
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

  def install
    system "shards", "install", "--without-development"
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
      shards = Formula["crystal"].bin/"shards"
      assert_match "Building", shell_output("#{shards} --without-development build test_app -Dwithout_mt")
    end
    assert_path_exists testpath/"test_app/bin/test_app"
  end
end
