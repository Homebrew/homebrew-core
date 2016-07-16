class MinioMc < Formula
  desc "ls, cp, mkdir, diff and rsync for filesystems and object storage"
  homepage "https://github.com/minio/mc"
  url "https://github.com/minio/mc/archive/RELEASE.2016-07-13T21-46-05Z.tar.gz"
  version "20160713214605"
  sha256 "611444a66ea3d2cc8fbb821147bcd3995c1956ef2aa9d62cd35f6d07f3f972cf"
  head "https://github.com/minio/mc.git"

  conflicts_with "midnight-commander", :because => "Both install a `mc` binary"

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath

    clipath = buildpath/"src/github.com/minio/mc"
    clipath.install Dir["*"]

    cd clipath do
      system "go", "build", "-o", bin/"mc"
    end
  end

  test do
    system bin/"mc", "mb", testpath/"test"
    assert_predicate testpath/"test", :exist?
  end
end
