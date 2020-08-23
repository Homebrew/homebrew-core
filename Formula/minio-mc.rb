class MinioMc < Formula
  desc "Replacement for ls, cp and other commands for object storage"
  homepage "https://github.com/minio/mc"
  url "https://github.com/minio/mc.git",
      tag:      "RELEASE.2020-08-20T00-23-01Z",
      revision: "ebb05ce469d556657a03fa944b199460bc3ec66e"
  version "20200820002301"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "c0004c068e4351ddb1d57c302742a57ecb33c74d7f60c7e80d239e0f688657a3" => :catalina
    sha256 "76479da8f371426d9e8060abe0728dc949386889f62e2a2bafba71069a790b6f" => :mojave
    sha256 "aa876b14400b462a0686ec12054e0c93b777b39b7e1252d2a7a21eddca7d263b" => :high_sierra
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
