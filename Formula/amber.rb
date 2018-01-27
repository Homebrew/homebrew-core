class Amber < Formula
  desc "CLI client for generating and scaffolding Amber web applications"
  homepage "https://www.amberframework.org/"
  url "https://github.com/amberframework/amber/archive/v0.6.4.tar.gz"
  sha256 "4b7489d16afc26e2847d4dc74dad54d2f5dc20d1a148a5e0da6bea991bcac68f"
  revision 1

  bottle do
    sha256 "7d01ba6ffbf8ee680005fdc0a8381b3177fef7abc96034ef1357c6aa5a30d181" => :high_sierra
    sha256 "45f1d027def58b03004b54863c8281501e3ebea2289e479794030d3c5a1656ce" => :sierra
    sha256 "683406f8597b747ace8dcc86c31a3640e78d8f347d812e4808272b395d5f76e7" => :el_capitan
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
