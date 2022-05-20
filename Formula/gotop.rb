class Gotop < Formula
  desc "Terminal based graphical activity monitor inspired by gtop and vtop"
  homepage "https://github.com/xxxserxxx/gotop"
  url "https://github.com/xxxserxxx/gotop/archive/v4.1.3.tar.gz"
  sha256 "c0a02276e718b988d1220dc452063759c8634d42e1c01a04c021486c1e61612d"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7580ba306a6bf56a4a40da70c0afa157d4ebf6572f64161e67d281a8ebf4357f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "557c44142c91a5fe28a7af8b51e765dd53b578c6e3d9f8574bafc5199fd1a081"
    sha256 cellar: :any_skip_relocation, monterey:       "ea38313cce0eceb5ad7b6fe59fdee06339e94077a4d52016ad3cd85e11957c38"
    sha256 cellar: :any_skip_relocation, big_sur:        "58d98a1062f1f11090072f7b51870bfb013034ad8fe40c98cf891f76c39ce1ae"
    sha256 cellar: :any_skip_relocation, catalina:       "318b906ab5b5239d105a3acc6d5bd9a28bea876d1938de5b43add11395880a55"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4311e6151f0613eae23fd73f9f2b9cf3a26d4968693e1b494ee7231bc464457d"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -X main.Version=#{version}
      -X main.BuildDate=#{time.strftime("%Y%m%dT%H%M%S")}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/gotop"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gotop --version").chomp

    system bin/"gotop", "--write-config"
    conf_path = if OS.mac?
      "Library/Application Support/gotop/gotop.conf"
    else
      ".config/gotop/gotop.conf"
    end
    assert_predicate testpath/conf_path, :exist?
  end
end
