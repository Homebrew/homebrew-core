class MinioMc < Formula
  desc "ls, cp, mkdir, diff and rsync for filesystems and object storage"
  homepage "https://github.com/minio/mc"
  url "https://github.com/minio/mc.git",
    :tag => "RELEASE.2017-02-06T20-16-19Z",
    :revision => "3fe080982e5e7da59dfcca9ad63ccdd64f04e053"
  version "20170206201619"

  bottle do
    cellar :any_skip_relocation
    sha256 "f9d37b9dc215c15a0356c4ee44c6eec30b04e393e03f74ca256ccb613684a319" => :sierra
    sha256 "c530131c11dc6b52886ebfc3bf3afba70f08ef854f7a44bad021e4d0f56a6d6f" => :el_capitan
    sha256 "9191a19ca875fc715c8703537d3d77da8c0d47070ca6c3c26a2e8ae39cf381ea" => :yosemite
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
