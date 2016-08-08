class Minio < Formula
  desc "object storage server compatible with Amazon S3"
  homepage "https://github.com/minio/minio"
  url "https://github.com/minio/minio.git", :tag => "RELEASE.2016-07-13T21-46-05Z", :revision => "3f27734c22212f224037a223439a425e6d2b653a"
  version "20160713214605"

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

    cd clipath do
      if build.head?
        system "go", "build", "-o", buildpath/"minio"
      else
        minio_release = `git tag --points-at HEAD`
        version = minio_release.gsub(/RELEASE\./, "")
        minio_version = version
        minio_commit = `git rev-parse HEAD`

        system "go", "build", "-ldflags", "-X main.minioVersion=#{minio_version} -X main.minioReleaseTag=#{minio_release} -X main.minioCommitID=#{minio_commit}", "-o", buildpath/"minio"
      end
    end

    bin.install buildpath/"minio"
  end

  test do
    minio_version = DateTime.parse(version).strftime("%Y-%m-%dT%H-%M-%SZ")
    assert_match minio_version, shell_output("#{bin}/minio version", "version doesn't match")
  end
end
