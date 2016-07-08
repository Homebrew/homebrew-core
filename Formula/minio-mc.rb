require "language/go"

class MinioMc < Formula
  desc "ls, cp, mkdir, diff and rsync for filesystems and object storage"
  homepage "https://github.com/minio/mc"
  url "https://github.com/minio/mc/archive/RELEASE.2016-06-03T18-48-37Z.tar.gz"
  version "20160603184837"
  sha256 "ac27ce934d5d71a1150eed69641a7ba801f3ae90c064ee944c154e311a5e6dbc"
  desc "object storage server compatible with Amazon S3"
  head "https://github.com/minio/mc.git"

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath

    clipath = buildpath/"src/github.com/minio/mc"
    clipath.install Dir["*"]

    cd buildpath/"src/github.com/minio/mc/" do
      system "go", "build", "-o", buildpath/"mc"
    end

    bin.install buildpath/"mc"
  end

  test do
    system "#{bin}/mc"
  end
end
