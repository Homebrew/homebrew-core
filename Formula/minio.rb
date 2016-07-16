require "language/go"

class Minio < Formula
  desc "object storage server compatible with Amazon S3"
  homepage "https://github.com/minio/minio"
  url "https://github.com/minio/minio/archive/RELEASE.2016-07-13T21-46-05Z.tar.gz"
  version "20160713214605"
  sha256 "40cd2faf5dd9503c20d2f5a5ad67277e960561fca5869a9d724d1efa763021df"
  head "https://github.com/minio/minio.git"

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath

    clipath = buildpath/"src/github.com/minio/minio"
    clipath.install Dir["*"]

    cd clipath do
      system "go", "build", "-o", buildpath/"minio"
    end

    bin.install buildpath/"minio"
  end

  test do
    system "#{bin}/minio", "version"
  end
end
