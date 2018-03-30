class Amber < Formula
  desc "CLI client for generating and scaffolding Amber web applications"
  homepage "https://www.amberframework.org/"
  url "https://github.com/amberframework/amber/archive/v0.7.1.tar.gz"
  sha256 "7775e23eba9f18d38099871ff9c8ad78d32f600213d0a72141d1e0ca3c708107"

  bottle do
    sha256 "0856ce59a596129d2b2af8dbc3d3bcc78114fd81d2c9217a538703eefda2f035" => :high_sierra
    sha256 "32c97a930cfa11c11fbcf4dd52778005963f2755220c5d4c0c6221cd225402ef" => :sierra
    sha256 "94d03936653371de944bdc4dd5f36b06977f89c9aee4bdfa544f6076ff9c71ff" => :el_capitan
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
