class MinioMc < Formula
  desc "Replacement for ls, cp and other commands for object storage"
  homepage "https://github.com/minio/mc"
  url "https://github.com/minio/mc.git",
      :tag      => "RELEASE.2020-04-04T05-28-55Z",
      :revision => "8cae137525a4ae986a1701b7ce3a3f5f065dfa31"
  version "20200404052855"

  bottle do
    cellar :any_skip_relocation
    sha256 "3ad97c550b1dafad5c268ef8e024db8b17db0db7e475c350ac3f6f002714974f" => :catalina
    sha256 "917dc10f17b1c7f5ef5a78266f65e62483f3b5106d3d421b3aa733963c351a97" => :mojave
    sha256 "1a4a90f4442d230b30cd97859d4956dd6f58ee4828876d34ce2d29910d762d89" => :high_sierra
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
