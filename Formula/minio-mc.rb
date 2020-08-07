class MinioMc < Formula
  desc "Replacement for ls, cp and other commands for object storage"
  homepage "https://github.com/minio/mc"
  url "https://github.com/minio/mc.git",
      tag:      "RELEASE.2020-07-31T23-34-13Z",
      revision: "6a98216c53b36d942ed77311338e4e93e391b902"
  version "20200731233413"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "29153445cca4006f2fe238253c764833eaf77b4222828cb1e92c76603f3096c5" => :catalina
    sha256 "e8e7fba9bf173cd49add1b069e8e80b01c8bef6b934300d0fafe1fed83420eb3" => :mojave
    sha256 "d350167601db0eee4286b5bef855da2814b1385847fd44097a39d2e0116f868e" => :high_sierra
  end

  depends_on "go" => :build

  conflicts_with "midnight-commander", because: "both install an `mc` binary"

  def install
    if build.head?
      system "go", "build", "-trimpath", "-o", bin/"mc"
    else
      minio_release = `git tag --points-at HEAD`.chomp
      minio_version = minio_release.gsub(/RELEASE\./, "").chomp.gsub(/T(\d+)-(\d+)-(\d+)Z/, 'T\1:\2:\3Z')
      minio_commit = `git rev-parse HEAD`.chomp
      proj = "github.com/minio/mc"

      system "go", "build", "-trimpath", "-o", bin/"mc", "-ldflags", <<~EOS
        -X #{proj}/cmd.Version=#{minio_version}
        -X #{proj}/cmd.ReleaseTag=#{minio_release}
        -X #{proj}/cmd.CommitID=#{minio_commit}
      EOS
    end
  end

  test do
    system bin/"mc", "mb", testpath/"test"
    assert_predicate testpath/"test", :exist?
  end
end
