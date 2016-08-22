class Minio < Formula
  desc "object storage server compatible with Amazon S3"
  homepage "https://github.com/minio/minio"
  url "https://github.com/minio/minio.git",
    :tag => "RELEASE.2016-08-21T02-44-47Z",
    :revision => "975eb319730c8db093b4744bf9e012356d61eef2"
  version "20160821024447"

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
        release = `git tag --points-at HEAD`.chomp
        version = release.gsub(/RELEASE\./, "").chomp.gsub(/T(\d+)\-(\d+)\-(\d+)Z/, 'T\1:\2:\3Z')
        commit = `git rev-parse HEAD`.chomp
        proj = "github.com/minio/minio/"

        system "go", "build", "-o", buildpath/"minio", "-ldflags", <<-EOS.undent
            -X #{proj}/cmd.Version=#{version}
            -X #{proj}/cmd.ReleaseTag=#{release}
            -X #{proj}/cmd.CommitID=#{commit}
            EOS
      end
    end

    bin.install buildpath/"minio"
  end

  test do
    system "#{bin}/minio", "version"
  end
end
