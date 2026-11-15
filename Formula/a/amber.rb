class Amber < Formula
  desc "Crystal web framework. Bare metal performance, productivity and happiness"
  homepage "https://amberframework.org/"
  url "https://github.com/amberframework/amber/archive/refs/tags/v1.5.0.tar.gz"
  sha256 "12c7b576a5f2e0dba53962ca23d18435526a2b685924783d57cb0d507bd93a03"
  license "MIT"
  revision 1

  bottle do
    sha256 arm64_golden_gate: "c5f84b98a879b6e845b43ade33c7cfbc3dd94b152e9510a69358c6bf9b5c7272"
    sha256 arm64_tahoe:       "3b6c4bed6b888ed5253130c3c131205d114823e2b99e8c4c6f67ca660a644e1f"
    sha256 arm64_sequoia:     "b70ddfdd4ef5bc01ae3c8c10d8ff0ef8683b5c819dc85cd6b656fb984d09086a"
    sha256 arm64_linux:       "37e4f44c761eab1d58a3698693dbcc5a2ce7375016b91373bede311874cfe653"
    sha256 x86_64_linux:      "8384d89aad94347eca84037576acddbc92f2103a896593837d1dc1c73febe301"
  end

  depends_on "bdw-gc"
  depends_on "crystal"
  depends_on "libyaml"
  depends_on "openssl@4"
  depends_on "pcre2"
  depends_on "sqlite"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  allow_network_access! :test

  def fetch
    system "shards", "install", "--without-development"
  end

  def install
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
      shards = formula_opt_bin("crystal")/"shards"
      assert_match "Building", shell_output("#{shards} --without-development build test_app -Dwithout_mt")
    end
    assert_path_exists testpath/"test_app/bin/test_app"
  end
end
