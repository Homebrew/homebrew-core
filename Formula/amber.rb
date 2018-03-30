class Amber < Formula
  desc "CLI client for generating and scaffolding Amber web applications"
  homepage "https://www.amberframework.org/"
  url "https://github.com/amberframework/amber/archive/v0.7.0.tar.gz"
  sha256 "ce6f08f68f237750f67220f38fc5fb4abf5058becd784eea6f8e34adef6d78bb"

  bottle do
    sha256 "7223a569a24fcc5c002081d97beb50213ce9ebeded3e163957d83eee52503207" => :high_sierra
    sha256 "ff76632172ba5be0ebea612103a90c735df39549d1933d91fe1826a63f8af22f" => :sierra
    sha256 "dc69480565df43e6df8b88f43fa94269efbe02b05fd38240ab2c3cb4fc5e0475" => :el_capitan
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
