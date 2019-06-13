class MinioMc < Formula
  desc "Replacement for ls, cp and other commands for object storage"
  homepage "https://github.com/minio/mc"
  url "https://github.com/minio/mc.git",
      :tag      => "RELEASE.2019-06-12T20-35-20Z",
      :revision => "ca26dac8e2e7d2e9b2d888e82f9edbf0873b7d2e"
  version "20190612203520"

  bottle do
    cellar :any_skip_relocation
    sha256 "ad836123473d60697b070cd8e38654fd72db847d02b525b74527e23a8209b37c" => :mojave
    sha256 "fea665bb4715bbe813fc1d13881bc423ffc4520515af9e1ba4b0a6db2c9dafce" => :high_sierra
    sha256 "e07c713ca1aedbd40e1aa268fb77696f935213bc4c22827a6965a19f2fbcb385" => :sierra
  end

  depends_on "go" => :build

  conflicts_with "midnight-commander", :because => "Both install a `mc` binary"

  def install
    ENV["GOPATH"] = buildpath
    ENV["GO111MODULE"] = "on"
    src = buildpath/"src/github.com/minio/mc"
    src.install buildpath.children
    src.cd do
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
