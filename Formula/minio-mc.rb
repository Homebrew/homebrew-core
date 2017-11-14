class MinioMc < Formula
  desc "ls, cp, mkdir, diff and rsync for filesystems and object storage"
  homepage "https://github.com/minio/mc"
  url "https://github.com/minio/mc.git",
    :tag => "RELEASE.2017-10-14T00-51-16Z",
    :revision => "785e14a725357b39e22b74483cd202e7effa6195"
  version "20171014005116"

  bottle do
    cellar :any_skip_relocation
    sha256 "5983a02a9c34db60616bbd25da656e0acbd6e47292c3a2c6013f5bdb0e73d98f" => :high_sierra
    sha256 "2b073dbbbca2c99b1f61e6f3dc5c3cf4ef3353e6395c3ea5ffa273e7f501b809" => :sierra
    sha256 "ea3b570ee90d88d0aca6bdfb99486eaa559a9e3cae541ce9f868c8a21d97e873" => :el_capitan
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
