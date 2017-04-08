require "language/go"

class Gor < Formula
  desc "Real-time HTTP traffic replay tool written in Go"
  homepage "https://gortool.com"
  url "https://github.com/buger/gor.git",
    :tag => "v0.16.0",
    :revision => "dcc7af4c09d8dcc36e6d0246bf4167390e3eca4f"
  head "https://github.com/buger/gor.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "91081c290396a2d8d52fa9f76b075af47764df3774f3a1d9a8cebdb111f0b665" => :sierra
    sha256 "664cff81e41321a473a087aa0ca465fa8df7ddc6844c468c3445fe9fb76cb6e5" => :el_capitan
    sha256 "07bfff5c49bdcd69bc145369d306a7b538b58586b4d6347639b92531b3074644" => :yosemite
    sha256 "aebc9f938167cc563d674b7acaf0110cb359d854fb98689135ae9fd09be0648d" => :mavericks
  end

  depends_on "go" => :build

  go_resource "github.com/Shopify/sarama" do
    url "https://github.com/Shopify/sarama.git",
        :revision => "d4ece5d05a86b2b64248f4943f872bea961ec835"
  end

  go_resource "github.com/davecgh/go-spew" do
    url "https://github.com/davecgh/go-spew.git",
        :revision => "346938d642f2ec3594ed81d874461961cd0faa76"
  end

  go_resource "github.com/eapache/go-resiliency" do
    url "https://github.com/eapache/go-resiliency.git",
        :revision => "b86b1ec0dd4209a588dc1285cdd471e73525c0b3"
  end

  go_resource "github.com/eapache/go-xerial-snappy" do
    url "https://github.com/eapache/go-xerial-snappy.git",
        :revision => "bb955e01b9346ac19dc29eb16586c90ded99a98c"
  end

  go_resource "github.com/eapache/queue" do
    url "https://github.com/eapache/queue.git",
        :revision => "44cc805cf13205b55f69e14bcb69867d1ae92f98"
  end

  go_resource "github.com/golang/snappy" do
    url "https://github.com/golang/snappy.git",
        :revision => "553a641470496b2327abcac10b36396bd98e45c9"
  end

  go_resource "github.com/klauspost/crc32" do
    url "https://github.com/klauspost/crc32.git",
        :revision => "1bab8b35b6bb565f92cbc97939610af9369f942a"
  end

  go_resource "github.com/pierrec/lz4" do
    url "https://github.com/pierrec/lz4.git",
        :revision => "f5b77fd73d83122495309c0f459b810f83cc291f"
  end

  go_resource "github.com/pierrec/xxHash" do
    url "https://github.com/pierrec/xxHash.git",
        :revision => "5a004441f897722c627870a981d02b29924215fa"
  end

  go_resource "github.com/rcrowley/go-metrics" do
    url "https://github.com/rcrowley/go-metrics.git",
        :revision => "1f30fe9094a513ce4c700b9a54458bbb0c96996c"
  end

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/buger/gor").install buildpath.children
    Language::Go.stage_deps resources, buildpath/"src"
    cd "src/github.com/buger/gor" do
      system "go", "build", "-o", bin/"gor", "-ldflags", "-X main.VERSION=#{version}"
      prefix.install_metafiles
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gor", 1)
  end
end
