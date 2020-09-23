class MinioMc < Formula
  desc "Replacement for ls, cp and other commands for object storage"
  homepage "https://github.com/minio/mc"
  url "https://github.com/minio/mc.git",
      tag:      "RELEASE.2020-09-18T00-13-21Z",
      revision: "0c1f1e29f107446a638cec50aca1ea37e4490393"
  version "20200918001321"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "9750629887fa58c2781b5d196e1b4698cd14732939be39129b76bd46838841a4" => :catalina
    sha256 "ef16e1f657e99451344fe207c322cd30f767de1403652dc2d32aea8637c44f1d" => :mojave
    sha256 "bd54790c65a26c3fd798a8574cf29ecd60305183b31b52a7cc4b8624489054c0" => :high_sierra
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
