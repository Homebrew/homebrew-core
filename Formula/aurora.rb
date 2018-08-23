require "language/go"

class Aurora < Formula
  desc "Beanstalkd queue server console"
  homepage "https://xuri.me/aurora"
  url "https://github.com/xuri/aurora/archive/2.1.tar.gz"
  sha256 "921f137e269c3abc4c352822cb73cc6edff69434d4685c8aabc24978e951e800"

  bottle do
    cellar :any_skip_relocation
    sha256 "93366557dd7e5e34c081fc3c26630208b88339f36bf9e5d33f7bd634b5d6d39f" => :mojave
    sha256 "64a70dcfd939245ccd64cee3f91c26374616eede20583e0a7e43314188d6e648" => :high_sierra
    sha256 "d2af9495df0060035181a1991a9e29a8723336b312ac794e4b9a716cc38ce58e" => :sierra
    sha256 "f0361aa58cf382e6daafb4cfd13dad45d398e4d6edff5cccd813efc165df199b" => :el_capitan
    sha256 "150614c06c473e101d34f65f0e4114581df8d9808a3ec36df9425c9fd5246c4d" => :yosemite
  end

  depends_on "go" => :build

  go_resource "github.com/BurntSushi/toml" do
    url "https://github.com/BurntSushi/toml.git",
        :revision => "a368813c5e648fee92e5f6c30e3944ff9d5e8895"
  end

  go_resource "github.com/rakyll/statik" do
    url "https://github.com/rakyll/statik.git",
        :revision => "89fe3459b5c829c32e89bdff9c43f18aad728f2f"
  end

  go_resource "github.com/xuri/aurora" do
    url "https://github.com/xuri/aurora.git",
        :revision => "ba6eea49d8e2ba665613b570b1532ac9fbfcfbbb"
  end

  def install
    ENV["GOPATH"] = buildpath
    Language::Go.stage_deps resources, buildpath/"src"
    (buildpath/"src/github.com/xuri").mkpath
    ln_s buildpath, "src/github.com/xuri/aurora"
    system "go", "build", "-o", bin/"aurora"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/aurora -v")
  end
end
