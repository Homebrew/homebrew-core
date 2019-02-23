require "language/go"

class Aurora < Formula
  desc "Beanstalkd queue server console"
  homepage "https://xuri.me/aurora"
  url "https://github.com/xuri/aurora/archive/2.2.tar.gz"
  sha256 "90ac08b7c960aa24ee0c8e60759e398ef205f5b48c2293dd81d9c2f17b24ca42"

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
        :revision => "9e064410954b74d18192cbd5b5ed09ef68da3b8e"
  end

  def install
    ENV["GOPATH"] = buildpath
    Language::Go.stage_deps resources, buildpath/"src"
    (buildpath/"src/github.com/xuri").mkpath
    ln_s buildpath, "src/github.com/xuri/aurora"
    rm buildpath/"go.mod"
    system "go", "build", "-o", bin/"aurora"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/aurora -v")
  end
end
