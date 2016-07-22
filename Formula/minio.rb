class Minio < Formula
  desc "object storage server compatible with Amazon S3"
  homepage "https://github.com/minio/minio"
  url "https://github.com/minio/minio/archive/RELEASE.2016-06-03T19-32-05Z.tar.gz"
  version "20160603193205"
  sha256 "8ecf52cc344c99f84bef632b8dfecf8fdc6a8493a541b2fe42f5b22d8bbfa802"
  head "https://github.com/minio/minio.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "29d5d319618c235dc75b86b9849b1b8f9d3ccc8c5b313c28e73167119ae43c4e" => :el_capitan
    sha256 "431a20fe6725e32f3a576937815b28e7af8fecfa1faab29e3c1d24d97edb0941" => :yosemite
    sha256 "c79ee7ccfea2b00db2b8792a479bac3142ce9567c7c69eade8a435b99600a77b" => :mavericks
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath

    clipath = buildpath/"src/github.com/minio/minio"
    clipath.install Dir["*"]

    cd buildpath/"src/github.com/minio/minio/" do
      system "go", "build", "-o", bin/"minio", "-v"
    end
  end

  test do
    system "#{bin}/minio"
  end
end
