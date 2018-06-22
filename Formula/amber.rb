class Amber < Formula
  desc "CLI client for generating and scaffolding Amber web applications"
  homepage "https://www.amberframework.org/"
  url "https://github.com/amberframework/amber/archive/v0.8.0.tar.gz"
  sha256 "d2706633fccfbce4102077b7455595d0935f5a542d85c68b744eb129edd64c6b"

  bottle do
    sha256 "47ffc9f948b296d3a652ae0ee8045e8f240d74a7aa20753ba9d69a7829fe5824" => :high_sierra
    sha256 "d2383650c2276ade18838c8938a09d5aec2a9d2d131727c2e8cb7877bf9dad1c" => :sierra
    sha256 "ab08c931d53f5018f104b0601d97726c13fe7986c52a767fa07d1c06fce1937b" => :el_capitan
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
