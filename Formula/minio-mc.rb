class MinioMc < Formula
  desc "ls, cp, mkdir, diff and rsync for filesystems and object storage"
  homepage "https://github.com/minio/mc"
  url "https://github.com/minio/mc.git",
    :tag => "RELEASE.2016-12-09T18-23-19Z",
    :revision => "64166319eeaed70cdb0e1a24ea97416a9600052e"
  version "20161209182319"

  bottle do
    cellar :any_skip_relocation
    sha256 "a93d3cce76dff4652a77e039013718c9b06812b0d2ad5d481c58dffa62c51324" => :sierra
    sha256 "f922bbe824c1574c1287cece8737534f33189ec4f0db4f3fc8f20d0186ea9cae" => :el_capitan
    sha256 "5a365062c622ffbbe546c7e82d6b91b3f9371cd9f5183afeba6ab8417685f340" => :yosemite
  end

  depends_on "go" => :build

  conflicts_with "midnight-commander", :because => "Both install a `mc` binary"

  def install
    ENV["GOPATH"] = buildpath

    clipath = buildpath/"src/github.com/minio/mc"
    clipath.install Dir["*"]

    cd clipath do
      if build.head?
        system "go", "build", "-o", buildpath/"mc"
      else
        minio_release = `git tag --points-at HEAD`.chomp
        minio_version = minio_release.gsub(/RELEASE\./, "").chomp.gsub(/T(\d+)\-(\d+)\-(\d+)Z/, 'T\1:\2:\3Z')
        minio_commit = `git rev-parse HEAD`.chomp
        proj = "github.com/minio/mc"

        system "go", "build", "-o", buildpath/"mc", "-ldflags", <<-EOS.undent
          -X #{proj}/cmd.Version=#{minio_version}
          -X #{proj}/cmd.ReleaseTag=#{minio_release}
          -X #{proj}/cmd.CommitID=#{minio_commit}
        EOS
      end
    end

    bin.install buildpath/"mc"
  end

  test do
    system bin/"mc", "mb", testpath/"test"
    assert File.exist?(testpath/"test")
  end
end
