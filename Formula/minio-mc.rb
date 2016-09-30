class MinioMc < Formula
  desc "ls, cp, mkdir, diff and rsync for filesystems and object storage"
  homepage "https://github.com/minio/mc"
  url "https://github.com/minio/mc.git",
    :tag => "RELEASE.2016-08-21T03-02-49Z",
    :revision => "768be74f74578137951f65874cfc2e454b64aca0"
  version "20160821030249"

  bottle do
    cellar :any_skip_relocation
    sha256 "8e95a7efe7ac147d3abc7dd97b0c16d815b9736bda35c9d0bf37b5a291172eed" => :sierra
    sha256 "3630fecfa0ee90f393a70ddb7a3af8e38450d548e61ba9f6193283726cf7f27a" => :el_capitan
    sha256 "8b8edb248da6713fd05459d053121459ee95ca3b7ccc3b43bdee95a4c4113c02" => :yosemite
    sha256 "5e1d16de0d9854d1f49a732d4f29ae69bba7ebd5af5f74c39879bf17a7597484" => :mavericks
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
