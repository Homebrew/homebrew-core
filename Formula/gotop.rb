class Gotop < Formula
  desc "Terminal based graphical activity monitor inspired by gtop and vtop"
  homepage "https://github.com/xxxserxxx/gotop"
  url "https://github.com/xxxserxxx/gotop/archive/v4.0.1.tar.gz"
  sha256 "38a34543ed828ed8cedd93049d9634c2e578390543d4068c19f0d0c20aaf7ba0"

  bottle do
    cellar :any_skip_relocation
    sha256 "b58594789760418f414c59d6894b0fb65be0e6c187ba82abe16ef85b0352152b" => :catalina
    sha256 "6774800971a481e6376ac3e014ce1ca05d617b565e664dc1ce57655f1c9d1c98" => :mojave
    sha256 "9089ba9be47d82d4af9fec33575e43ce50aabf3676354484381ea23d5e6ba68a" => :high_sierra
  end

  depends_on "go" => :build

  def install
    time = `date +%Y%m%dT%H%M%S`.chomp
    system "go", "build", *std_go_args, "-ldflags",
           "-X main.Version=#{version} -X main.BuildDate=#{time}", "./cmd/gotop"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gotop --version").chomp

    system bin/"gotop", "--write-config"
    assert_predicate testpath/"Library/Application Support/gotop/gotop.conf", :exist?
  end
end
