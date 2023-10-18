class Grpcui < Formula
  desc "Interactive web UI for gRPC, along the lines of postman"
  homepage "https://github.com/fullstorydev/grpcui"
  url "https://github.com/fullstorydev/grpcui/archive/v1.3.2.tar.gz"
  sha256 "81930a16c072c50182d7fc14a4030b2833c1a8472ee944352ed36189b5f4d260"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8279c4422bebd889140866c0f74ed3ef3e671a85432f96489853ca353e89cdc5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7c529e2a8c93230236eab974e44c36cf5d2d1b9cff7ec31469bf8352bee392ed"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ddcaadd479e8e52d49cb9c5b8b9ab9eb9d709dda46d7b5d4fa769c2aaf5367c2"
    sha256 cellar: :any_skip_relocation, sonoma:         "93459ce39d459bb9bbb5af8d40023f283949dfd7f4e97871c2c28283276eb94d"
    sha256 cellar: :any_skip_relocation, ventura:        "e60adba072507d2003afa3fe4d8d979552a424eb0b05b026d0bc263ad8899862"
    sha256 cellar: :any_skip_relocation, monterey:       "3d59dde31a65669bd2b085e652f4e41089e72d59ef5afae5191064f657856094"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9c026df3070b926da7ca7069951e5a57b736bca77336341f273110eda4d187c0"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}"), "./cmd/grpcui"
  end

  test do
    host = "no.such.host.dev"
    output = shell_output("#{bin}/grpcui #{host}:999 2>&1", 1)
    assert_match(/Failed to dial target host "#{Regexp.escape(host)}:999":.*: no such host/, output)
  end
end
