class MinioMc < Formula
  desc "ls, cp, mkdir, diff and rsync for filesystems and object storage"
  homepage "https://github.com/minio/mc"
  url "https://github.com/minio/mc.git",
    :tag => "RELEASE.2017-10-14T00-51-16Z",
    :revision => "785e14a725357b39e22b74483cd202e7effa6195"
  version "20171014005116"

  bottle do
    cellar :any_skip_relocation
    sha256 "b9dc081db0b4f72cad2a5c569c60271de5b2453e1ffd5e3985cd70f7fea6bc0b" => :high_sierra
    sha256 "ca3cb52fd8f8aae955d386d07aac0371f2b50fb7a21eb4f2386da269932d5405" => :sierra
    sha256 "e0704974e3071a859c5927a90d47cfabbc341531aaaaf466fda32abdaa4dd005" => :el_capitan
    sha256 "2fbb282c1986ab5cdedfd475523b068891f0b03af16a310fe0db5905d96d00dc" => :yosemite
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
    assert_predicate testpath/"test", :exist?
  end
end
