class Amber < Formula
  desc "CLI client for generating and scaffolding Amber web applications"
  homepage "https://www.amberframework.org/"
  url "https://github.com/amberframework/amber/archive/v0.8.0.tar.gz"
  sha256 "d2706633fccfbce4102077b7455595d0935f5a542d85c68b744eb129edd64c6b"

  bottle do
    rebuild 1
    sha256 "f24fc9f842200552ccb96f325736293a80c2ac641d17841bab6080523895f892" => :high_sierra
    sha256 "2df68ee8f81181e2bd3ef81533be781156e7b57e1003d24c34c3efa84fbcb387" => :sierra
    sha256 "37fc3b2e4f444f20c587e190850e460f0973a21125e813d1c3f9fc863caeae69" => :el_capitan
  end

  depends_on "crystal"

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
