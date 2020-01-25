class MinioMc < Formula
  desc "Replacement for ls, cp and other commands for object storage"
  homepage "https://github.com/minio/mc"
  url "https://github.com/minio/mc.git",
      :tag      => "RELEASE.2020-01-25T03-02-19Z",
      :revision => "b70a79e39bbde69d76e557a7c10842e3eb053b47"
  version "20200125030219"

  bottle do
    cellar :any_skip_relocation
    sha256 "e71fefaac09c102969ea8258b3a5c63ccc0028f5bf1c9bf019157399fa6464f4" => :catalina
    sha256 "b396e766569b74228c466f99c666ee2d696c312b768d9f937c5d9f1533f39250" => :mojave
    sha256 "df55dc10705219a865a8aac9f245fd8811dc9e138716853ada99d705cd435340" => :high_sierra
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
