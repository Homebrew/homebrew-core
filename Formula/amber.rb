class Amber < Formula
  desc "CLI client for generating and scaffolding Amber web applications"
  homepage "https://www.amberframework.org/"
  url "https://github.com/amberframework/amber/archive/v0.6.7.tar.gz"
  sha256 "a70b62cd3e470005a5ac804273088f444613942eafdfc1d237b6444f1e4851f2"

  bottle do
    sha256 "1ceffce4e2f72e496c5d8ce8d3f14eb96bcfe065f50ff59f7e6779a36d7b0540" => :high_sierra
    sha256 "a9f67a8ded238efc72d7c86c737478431fb312d8c5e9c959e9c041f83702dd4e" => :sierra
    sha256 "2c5c01c2429399bb40a83536210af18fcb7b7ca41facbffffc82fe42c5e00e6c" => :el_capitan
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
