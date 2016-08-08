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

    minio_version = DateTime.parse(version).strftime("%Y-%m-%dT%H:%M:%SZ")
    minio_release = "RELEASE.#{minio_version}"
    minio_commit = "3f27734c22212f224037a223439a425e6d2b653a"

    cd clipath do
      if build.head?
        system "go", "build", "-o", buildpath/"minio"
      else

        system "go", "build", "-ldflags", "-X main.minioVersion=#{minio_version} -X main.minioReleaseTag=#{minio_release} -X main.minioCommitID=#{minio_commit}", "-o", buildpath/"minio"
      end
    end

    bin.install buildpath/"minio"
  end

  test do
    minio_version = DateTime.parse(version).strftime("%Y-%m-%dT%H:%M:%SZ")
    assert_match minio_version, shell_output("#{bin}/minio version", "version doesn't match")
  end
end
