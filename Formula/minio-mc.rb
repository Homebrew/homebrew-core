class MinioMc < Formula
  desc "ls, cp, mkdir, diff and rsync for filesystems and object storage"
  homepage "https://github.com/minio/mc"
  url "https://github.com/minio/mc.git",
      :tag      => "RELEASE.2018-11-30T01-52-08Z",
      :revision => "a91204ea6fb507b62253a6b1cee4583cdfc53115"
  version "20181130015208"

  bottle do
    cellar :any_skip_relocation
    sha256 "5207c5feb4a6f0875409a6d78afdda051483963a66a0cbbc8a6fdcc0ce6b809a" => :mojave
    sha256 "cbbe009c30c0d81e7b21ea4d33f466523c8678e27282004d14fb87d2d7bceada" => :high_sierra
    sha256 "2e30735ab03a915ef6c261eb8e5f039de2f9ea9dd1edda7b07904f3b1b421a9e" => :sierra
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
