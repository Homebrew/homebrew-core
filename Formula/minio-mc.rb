class MinioMc < Formula
  desc "ls, cp, mkdir, diff and rsync for filesystems and object storage"
  homepage "https://github.com/minio/mc"
  url "https://github.com/minio/mc.git",
    :tag => "RELEASE.2017-02-06T20-16-19Z",
    :revision => "3fe080982e5e7da59dfcca9ad63ccdd64f04e053"
  version "20170206201619"

  bottle do
    cellar :any_skip_relocation
    sha256 "1505131f2ca44de8d0c28c919b70efa1f5acc5172de0fd84c33b703f063b05a9" => :sierra
    sha256 "c2d952413c2d49b847d338372f8db95cf04ad01c1a2cc46d69603140631b9e77" => :el_capitan
    sha256 "1eced2673f13064ae7898dfdd0959a3e689e48f638f447a5da3b6fc3dc90a27b" => :yosemite
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
