class MinioMc < Formula
  desc "ls, cp, mkdir, diff and rsync for filesystems and object storage"
  homepage "https://github.com/minio/mc"
  head "https://github.com/minio/mc.git"
  url "https://github.com/minio/mc.git",
    :tag => "RELEASE.2016-08-21T03-02-49Z",
    :revision => "768be74f74578137951f65874cfc2e454b64aca0"
  version "20160821030249"

  bottle do
    cellar :any_skip_relocation
    sha256 "84ba2516edbd0b914d7b4b0bb13c7ef688da9c6cb1d19b8f169e8bd63de8df4d" => :el_capitan
    sha256 "d7cc78245118c15d93a46c615ef93f84da13c81f8272b007a50187dc108afc4d" => :yosemite
    sha256 "b25362a60bc8bb8f9bc3eb54b8237dfc658fe0bd6f74438e8dcbc2752cdc2a57" => :mavericks
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

        system "go", "build", "-ldflags", "-X github.com/minio/mc/cmd.Version=#{minio_version} -X github.com/minio/mc/cmd.ReleaseTag=#{minio_release} -X github.com/minio/mc/cmd.CommitID=#{minio_commit}", "-o", buildpath/"mc"
      end
    end

    bin.install buildpath/"mc"
  end

  test do
    system bin/"mc", "mb", testpath/"test"
    assert File.exist?(testpath/"test")
  end
end
