class Databend < Formula
  desc "Elastic, reliable serverless data warehouse, offers blazing fast query"
  homepage "https://databend.rs/"
  url "https://github.com/datafuselabs/databend/archive/refs/tags/v0.6.36-nightly.tar.gz"
  sha256 "73c4957bd51745b4bacd16f6b7324e14f74b68b1ff53b165ad780e8b23667876"
  license "Apache-2.0"

  livecheck do
    url :url
  end

  depends_on "rustup-init" => :build

  def install
    ENV["CARGO_HOME"] = "#{ENV["HOME"]}/.cargo"
    system "rustup-init", "-y"
    bins=%w[databend-query databend-benchmark databend-meta]
    # https://github.com/rust-lang/cargo/issues/7124
    system "#{ENV["CARGO_HOME"]}/bin/cargo", "build", "--release", *bins.map { |b| "--bin=#{b}" }, "--locked"
    bins.each do |b|
      bin.install "target/release/#{b}"
    end
  end

  test do
    system "true"
  end
end
