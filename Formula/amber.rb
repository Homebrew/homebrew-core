class Amber < Formula
  desc "CLI client for generating and scaffolding Amber web applications"
  homepage "https://www.amberframework.org/"
  url "https://github.com/amberframework/amber/archive/v0.8.0.tar.gz"
  sha256 "d2706633fccfbce4102077b7455595d0935f5a542d85c68b744eb129edd64c6b"

  bottle do
    sha256 "dda2253c6445c941a236ba5559c85dd4ab6b012667276a12ad55bc8bcbb7a3e3" => :high_sierra
    sha256 "933bdffe10c21c5c05c593d49480e4811fc448c01dadcfc72eb97262b757dafa" => :sierra
    sha256 "4479e087a87ec39b344a0f8b1b6f0d2f09c6277d919e6d397ce84cbb9fa084c8" => :el_capitan
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
