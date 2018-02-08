class Amber < Formula
  desc "CLI client for generating and scaffolding Amber web applications"
  homepage "https://www.amberframework.org/"
  url "https://github.com/amberframework/amber/archive/v0.6.7.tar.gz"
  sha256 "a70b62cd3e470005a5ac804273088f444613942eafdfc1d237b6444f1e4851f2"

  bottle do
    sha256 "65d14b51db6a85c027b15c306742a901a290f7e9febe887fac2cbb56a39b8885" => :high_sierra
    sha256 "7ff6c34e750a418d17d9586f7d3e1dcb6f93d0ffd7be038659209bfd57fcdd3a" => :sierra
    sha256 "21ce76e3f32463c979685b05c3958379243b168cc4ff504b21f3bc6b85a30b71" => :el_capitan
  end

  depends_on "crystal-lang"

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
