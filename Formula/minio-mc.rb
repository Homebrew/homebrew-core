class MinioMc < Formula
  desc "Replacement for ls, cp and other commands for object storage"
  homepage "https://github.com/minio/mc"
  url "https://github.com/minio/mc.git",
      :tag      => "RELEASE.2019-03-13T21-05-06Z",
      :revision => "ecfd4526a3b6071330a0093c80815b59d451afd0"
  version "20190313210506"

  bottle do
    cellar :any_skip_relocation
    sha256 "5389e9f46760bec7d0695dafe979f6aa2731ad6b36696518e94df4edcaafa92e" => :mojave
    sha256 "9ce1401f31b83e78edb79b6679adb2318d0b0ec2d431c5b272f57df9adb482c4" => :high_sierra
    sha256 "860658092f46185d3f542bd847740041cdadb0eba7476802572f49681991e10d" => :sierra
  end

  depends_on "go" => :build

  conflicts_with "midnight-commander", :because => "Both install a `mc` binary"

  def install
    ENV["GOPATH"] = buildpath

    clipath = buildpath/"src/github.com/minio/mc"
    clipath.install Dir["*"]

    cd clipath do
      if build.head?
        system "go", "build", "-o", buildpath/"mc"
      else
        minio_release = `git tag --points-at HEAD`.chomp
        minio_version = minio_release.gsub(/RELEASE\./, "").chomp.gsub(/T(\d+)\-(\d+)\-(\d+)Z/, 'T\1:\2:\3Z')
        minio_commit = `git rev-parse HEAD`.chomp
        proj = "github.com/minio/mc"

        system "go", "build", "-o", buildpath/"mc", "-ldflags", <<~EOS
          -X #{proj}/cmd.Version=#{minio_version}
          -X #{proj}/cmd.ReleaseTag=#{minio_release}
          -X #{proj}/cmd.CommitID=#{minio_commit}
        EOS
      end
    end

    bin.install buildpath/"mc"
    prefix.install_metafiles
  end

  test do
    system bin/"mc", "mb", testpath/"test"
    assert_predicate testpath/"test", :exist?
  end
end
