require "language/go"

# we're using an ugly workaround here, because the tar is being extracted in builddir,
# and we need to build into the $GOPATH/src/github.com/minio/minio/. Softlinking isn't working
# with every shell. So we're using the go_resource to go get the correct revision, while
# actually not using the tar from the url. The url isn't possible to skip.

class Minio < Formula
  desc "object storage server compatible with Amazon S3"
  homepage "https://github.com/minio/minio"
  url "https://github.com/minio/minio/archive/RELEASE.2016-06-03T19-32-05Z.tar.gz"
  version "20160603193205"
  sha256 "8ecf52cc344c99f84bef632b8dfecf8fdc6a8493a541b2fe42f5b22d8bbfa802"
  head "https://github.com/minio/minio.git"

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath

    clipath = buildpath/"src/github.com/minio/minio"
    clipath.install Dir["*"]

    cd buildpath/"src/github.com/minio/minio/" do
      system "go", "build", "-o", buildpath/"minio"
    end

    bin.install buildpath/"minio"
  end

  test do
    system "#{bin}/minio"
  end
end
