class MinioMc < Formula
  desc "Replacement for ls, cp and other commands for object storage"
  homepage "https://github.com/minio/mc"
  url "https://github.com/minio/mc.git",
      :tag      => "RELEASE.2018-12-12T19-02-22Z",
      :revision => "69f967b3f32c2d74b4c7ea8f3615829ea58f0d08"
  version "20181212190222"

  bottle do
    cellar :any_skip_relocation
    sha256 "c3e9be1fa1e44aa0f63f948a369183b52b8dac4d83202b1c41e5ecc2f4660cc9" => :mojave
    sha256 "dfd08cecab94e89b9a6a72e2b9919fc15d04beeb2c1db40bb5e6e212937ff84e" => :high_sierra
    sha256 "2df981f9a7de3edcbe93d83ffe66cb81f51334e04da9c8d9197493c8d801d562" => :sierra
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
