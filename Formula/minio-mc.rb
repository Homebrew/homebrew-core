class MinioMc < Formula
  desc "Replacement for ls, cp and other commands for object storage"
  homepage "https://github.com/minio/mc"
  url "https://github.com/minio/mc.git",
      :tag      => "RELEASE.2020-03-14T01-23-37Z",
      :revision => "5b5d65a142c5562e412de022a3114e83378096a5"
  version "20200314012337"

  bottle do
    cellar :any_skip_relocation
    sha256 "0a866e0cdffb6b69cca16a4aba7d7c0dea7ed652c62ac94b5d7c95202f554bed" => :catalina
    sha256 "3ad6b3f1b0ebbe165bdc4597fd575455137f93a3c6487778797b9c43040de4d6" => :mojave
    sha256 "ad05b75e154e6c62e38f9fbfe2c6f5b30c52fd47029ed56f21460a10c6731501" => :high_sierra
  end

  depends_on "go" => :build

  conflicts_with "midnight-commander", :because => "Both install a `mc` binary"

  def install
    if build.head?
      system "go", "build", "-trimpath", "-o", bin/"mc"
    else
      minio_release = `git tag --points-at HEAD`.chomp
      minio_version = minio_release.gsub(/RELEASE\./, "").chomp.gsub(/T(\d+)\-(\d+)\-(\d+)Z/, 'T\1:\2:\3Z')
      minio_commit = `git rev-parse HEAD`.chomp
      proj = "github.com/minio/mc"

      system "go", "build", "-trimpath", "-o", bin/"mc", "-ldflags", <<~EOS
        -X #{proj}/cmd.Version=#{minio_version}
        -X #{proj}/cmd.ReleaseTag=#{minio_release}
        -X #{proj}/cmd.CommitID=#{minio_commit}
      EOS
    end

    prefix.install_metafiles
  end

  test do
    system bin/"mc", "mb", testpath/"test"
    assert_predicate testpath/"test", :exist?
  end
end
