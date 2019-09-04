require "language/go"

class Ossutil < Formula
  desc "a user friendly command-line tool to access AliCloud OSS"
  homepage "https://www.aliyun.com/product/oss"
  url "https://github.com/aliyun/ossutil.git",
      :tag      => "v1.6.6",
      :revision => "70f26cd844d77a4cb90a4260d282d127d73d8061"
  head "https://github.com/aliyun/ossutil.git"

  depends_on "go" => :build

  go_resource "github.com/aliyun/aliyun-oss-go-sdk" do
    url "https://github.com/aliyun/aliyun-oss-go-sdk.git",
        :revision => "2cd503a98eeff1992d8d45c7f6d896c1660943fb"
  end

  go_resource "github.com/alyu/configparser" do
    url "https://github.com/alyu/configparser.git",
        :revision => "c505e6011694d3c8c1accccea3c9f57eef22afb1"
  end

  go_resource "github.com/droundy/goopt" do
    url "https://github.com/droundy/goopt.git",
        :revision => "0b8effe182da161d81b011aba271507324ecb7ab"
  end

  go_resource "github.com/satori/go.uuid" do
    url "https://github.com/satori/go.uuid.git",
        :revision => "b2ce2384e17bbe0c6d34077efa39dbab3e09123b"
  end

  go_resource "github.com/syndtr/goleveldb" do
    url "https://github.com/syndtr/goleveldb.git",
        :revision => "9d007e481048296f09f59bd19bb7ae584563cd95"
  end

  go_resource "github.com/golang/snappy" do
    url "https://github.com/golang/snappy.git",
        :revision => "2a8bb927dd31d8daada140a5d09578521ce5c36a"
  end

  go_resource "golang.org/x/time" do
    url "https://go.googlesource.com/time.git",
        :revision => "9d24e82272b4f38b78bc8cff74fa936d31ccd8ef"
  end

  def install
    ENV["GOPATH"] = buildpath

    Language::Go.stage_deps resources, buildpath/"src"

    (buildpath/"src/github.com/aliyun").mkpath
    ln_s buildpath, buildpath/"src/github.com/aliyun/ossutil"
    system "go", "build", "-o", bin/"ossutil", "github.com/aliyun/ossutil"
  end

  test do
    system "#{bin}/ossutil", "--version"
  end
end
