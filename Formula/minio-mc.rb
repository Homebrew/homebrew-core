class MinioMc < Formula
  desc "ls, cp, mkdir, diff and rsync for filesystems and object storage"
  homepage "https://github.com/minio/mc"
  url "https://github.com/minio/mc.git",
      :tag      => "RELEASE.2018-10-18T00-40-05Z",
      :revision => "0dd32c1b26f05e7f94f76f2ceb62b5229836b009"
  version "20181018004005"

  bottle do
    cellar :any_skip_relocation
    sha256 "de0e260bb6b612ae50d0a80bcbce6f1d3288a3dc1f02f37f326062c6deea97df" => :mojave
    sha256 "3d60d601f3364f4974c7a0a2408fb230e09f8f7d5ca4ee9874ac940dd1c0aec8" => :high_sierra
    sha256 "71c45bf304860a000b57052a9ad49b19b1cb2c72073b893e8ea8ac2100719aa6" => :sierra
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

        system "go", "build", "-o", buildpath/"mc", "-ldflags", <<~EOS
          -X #{proj}/cmd.Version=#{minio_version}
          -X #{proj}/cmd.ReleaseTag=#{minio_release}
          -X #{proj}/cmd.CommitID=#{minio_commit}
        EOS
      end
    end

    bin.install buildpath/"mc"
    prefix.install_metafiles
  end

  test do
    system bin/"mc", "mb", testpath/"test"
    assert_predicate testpath/"test", :exist?
  end
end
