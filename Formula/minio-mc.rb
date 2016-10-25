class MinioMc < Formula
  desc "ls, cp, mkdir, diff and rsync for filesystems and object storage"
  homepage "https://github.com/minio/mc"
  url "https://github.com/minio/mc.git",
    :tag => "RELEASE.2016-10-07T01-56-22Z",
    :revision => "75d55783c01c9849055f76cca146390d2d5df631"
  version "20161007015622"

  bottle do
    cellar :any_skip_relocation
    sha256 "b31ebe5eae4e1a57972a43b15491aa73a831bf5f3534a7852e3bd07ec4e89d9d" => :sierra
    sha256 "316676ec312458bd5a74e803d6b8086b3a11c703d30e8de59bada5327f61d7c2" => :el_capitan
    sha256 "37ffc7d0ae9db62a9931d2af3f0c2e4136fe56c607f926bca553b8135a114008" => :yosemite
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
