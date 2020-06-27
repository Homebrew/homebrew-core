class MinioMc < Formula
  desc "Replacement for ls, cp and other commands for object storage"
  homepage "https://github.com/minio/mc"
  url "https://github.com/minio/mc.git",
      :tag      => "RELEASE.2020-06-26T19-56-55Z",
      :revision => "bb3c0d45f2e64eab2b83e7f5376e1b621f0821a9"
  version "20200626195655"

  bottle do
    cellar :any_skip_relocation
    sha256 "7c8ce705946e1d97ca7d53b43cc8a628e95e5112c7286c0170a503b1506332ca" => :catalina
    sha256 "e5c7b00da0c74b7ce333618f3733ad9a1e3ab31781b3ad97d58fa6b05dae89c8" => :mojave
    sha256 "9d3e2179c675afdbdc603144c9e0af701d5e1478775e6729a3d867d26bcb31b4" => :high_sierra
  end

  depends_on "go" => :build

  conflicts_with "midnight-commander", :because => "Both install a `mc` binary"

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

    prefix.install_metafiles
  end

  test do
    system bin/"mc", "mb", testpath/"test"
    assert_predicate testpath/"test", :exist?
  end
end
