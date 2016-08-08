class MinioMc < Formula
  desc "ls, cp, mkdir, diff and rsync for filesystems and object storage"
  homepage "https://github.com/minio/mc"
  url "https://github.com/minio/mc/archive/RELEASE.2016-07-13T21-46-05Z.tar.gz"
  version "20160713214605"
  sha256 "611444a66ea3d2cc8fbb821147bcd3995c1956ef2aa9d62cd35f6d07f3f972cf"
  head "https://github.com/minio/mc.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "84ba2516edbd0b914d7b4b0bb13c7ef688da9c6cb1d19b8f169e8bd63de8df4d" => :el_capitan
    sha256 "d7cc78245118c15d93a46c615ef93f84da13c81f8272b007a50187dc108afc4d" => :yosemite
    sha256 "b25362a60bc8bb8f9bc3eb54b8237dfc658fe0bd6f74438e8dcbc2752cdc2a57" => :mavericks
  end

  depends_on "go" => :build

  conflicts_with "midnight-commander", :because => "Both install a `mc` binary"

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
    assert File.exist?(testpath/"test")
  end
end
