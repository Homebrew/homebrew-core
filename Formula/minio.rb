class Minio < Formula
  desc "object storage server compatible with Amazon S3"
  homepage "https://github.com/minio/minio"
  url "https://github.com/minio/minio.git",
    :tag => "RELEASE.2016-07-13T21-46-05Z",
    :revision => "3f27734c22212f224037a223439a425e6d2b653a"
  version "20160713214605"

  bottle do
    cellar :any_skip_relocation
    sha256 "358078c885c875d5c3ea5e0e00b68c49325ce310fb8fc2db65d75819c84ae732" => :el_capitan
    sha256 "508a636d0fba7a1b82177b1c8d6a2c8c395e296e38abd6dafd663101cc853d7b" => :yosemite
    sha256 "e1f7a59413d1b4b0988011a04400dd0ee9fb07ba4b0d60c71ffae4ff249f13aa" => :mavericks
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath

    clipath = buildpath/"src/github.com/minio/minio"
    clipath.install Dir["*"]

    cd clipath do
      if build.head?
        system "go", "build", "-o", buildpath/"minio"
      else
        minio_release = `git tag --points-at HEAD`.chomp
        minio_version = minio_release.gsub(/RELEASE\./, "").chomp
        minio_commit = `git rev-parse HEAD`.chomp

        system "go", "build", "-ldflags", "-X main.minioVersion=#{minio_version} -X main.minioReleaseTag=#{minio_release} -X main.minioCommitID=#{minio_commit}", "-o", buildpath/"minio"
      end
    end

    bin.install buildpath/"minio"
  end

  test do
    system "#{bin}/minio", "version"
  end
end
