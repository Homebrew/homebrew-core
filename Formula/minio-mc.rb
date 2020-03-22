class MinioMc < Formula
  desc "Replacement for ls, cp and other commands for object storage"
  homepage "https://github.com/minio/mc"
  url "https://github.com/minio/mc.git",
      :tag      => "RELEASE.2020-03-14T01-23-37Z",
      :revision => "5b5d65a142c5562e412de022a3114e83378096a5"
  version "20200314012337"

  bottle do
    cellar :any_skip_relocation
    sha256 "eef4607db190e2514f77e67bf0db82dac5200d1dda034cd146ae9d585fd41d78" => :catalina
    sha256 "86d94729e3c9ea7617509c7b58002588703fe51b41d0867108af064f18d2afc2" => :mojave
    sha256 "999ea2a246a3b2c181c53d4cc867ebe827737943a135190474a2c32dee981e9a" => :high_sierra
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
