class MinioMc < Formula
  desc "Replacement for ls, cp and other commands for object storage"
  homepage "https://github.com/minio/mc"
  url "https://github.com/minio/mc.git",
      :tag      => "RELEASE.2020-04-25T00-43-23Z",
      :revision => "201831912545c5a16ca4c797204eabb4d16ee7ac"
  version "20200425004323"

  bottle do
    cellar :any_skip_relocation
    sha256 "31dd58c7c1573165debc979f3e3f80363aa9c52ee1e4c20b039a45bc102e650d" => :catalina
    sha256 "3269ed588d0a3a8e7d48011d43bd48c709d6e2dcb377c6d24fb69d30ea394ad1" => :mojave
    sha256 "1b56c64662490393245a9322bc3e85a50d25329a9834abcf6f26799709052b29" => :high_sierra
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
