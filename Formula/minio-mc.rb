class MinioMc < Formula
  desc "Replacement for ls, cp and other commands for object storage"
  homepage "https://github.com/minio/mc"
  url "https://github.com/minio/mc.git",
      :tag      => "RELEASE.2018-12-27T00-37-49Z",
      :revision => "4e7eeb0725abcd36b54a37636ff89f29c3238fd8"
  version "20181227003749"

  bottle do
    cellar :any_skip_relocation
    sha256 "2162e615cbd452f6dacb921b055394f9b4190d4c4d417301e63882c7c81f13fc" => :mojave
    sha256 "63cd511b864bcc8ee05e2980ccf82b9a0fce63dc02b8ce7b788bc1629cdd4e7a" => :high_sierra
    sha256 "1c39766aeaef589c9094b7c1cb6fdead614e6ec6d473ad930ed97e113878f561" => :sierra
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
