class Amber < Formula
  desc "CLI client for generating and scaffolding Amber web applications"
  homepage "https://www.amberframework.org/"
  url "https://github.com/amberframework/amber/archive/v0.6.4.tar.gz"
  sha256 "4b7489d16afc26e2847d4dc74dad54d2f5dc20d1a148a5e0da6bea991bcac68f"

  bottle do
    sha256 "b2f92639b17c291b2d69f5be394d71349ac4fca644f28c62d648f55c686a117f" => :high_sierra
    sha256 "10b1f682f761829ef6e22c49715c319d872a45a67b1bf5ac69a6e6566585bddc" => :sierra
    sha256 "4cef2d95cf74003084bc514115ec67a5c4957ba1eb60f3193fdafec6c35f3e66" => :el_capitan
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
