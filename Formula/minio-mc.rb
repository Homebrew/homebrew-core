class MinioMc < Formula
  desc "Replacement for ls, cp and other commands for object storage"
  homepage "https://github.com/minio/mc"
  url "https://github.com/minio/mc.git",
      :tag      => "RELEASE.2020-02-14T19-35-50Z",
      :revision => "2f2aecb09dd15cc65ca828dc7946d4de98dbc7df"
  version "20200214193550"

  bottle do
    cellar :any_skip_relocation
    sha256 "a4da085412257cc282545202abaf84f7804fc62b3c5bbf48bbc0c93d7be7cd2d" => :catalina
    sha256 "14eb7c353e1eefafc795419a4b89b70ad20c33bc9247ea1bd7a08c99c3357a2d" => :mojave
    sha256 "7ddd1ffff5e751647d3433749361b0cab29dc34513df47244bf7589a5f722dde" => :high_sierra
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
