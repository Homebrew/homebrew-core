class Phoneinfoga < Formula
  desc "Information gathering framework for phone numbers"
  homepage "https://sundowndev.github.io/phoneinfoga/"
  url "https://github.com/sundowndev/phoneinfoga/archive/v2.10.4.tar.gz"
  sha256 "4ff3ee5960b966fda00b344a692553b7660f7bb16cd717940e875746fd1b9256"
  license "GPL-3.0-only"
  head "https://github.com/sundowndev/phoneinfoga.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "177a1ff913a76855acff8bb044a11ecc8472b50509e3d197f49ad953cae31deb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "42db961b6d70d4c08840dd6058d639dc5ba4e4ba12d6111701300059eb691b52"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "082cfa44a2364f8e2e2c89cec6d6715919ff24e6cae3b4d82c612d2a03089fb0"
    sha256 cellar: :any_skip_relocation, ventura:        "be5e0eae2753a4d5f4d08b9c91d311d7405695085dad4ab82c44dfc48e3061a2"
    sha256 cellar: :any_skip_relocation, monterey:       "346862583bb08bd9ca45c66ef9b4072610cddb8b48cecefac28349dc62130809"
    sha256 cellar: :any_skip_relocation, big_sur:        "005ed1a4c0d86fb066bed2e9403c7a6fb6c13b2073b287870076bcf3affc9395"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f1861522cfea35b464ce79217a2c1869ec93157227802bf3ed7d85e76db64360"
  end

  depends_on "go" => :build
  depends_on "yarn" => :build
  depends_on "node"

  def install
    cd "web/client" do
      system "yarn", "install", "--immutable"
      system "yarn", "build"
    end

    ldflags = %W[
      -s -w
      -X github.com/sundowndev/phoneinfoga/v2/build.Version=v#{version}
      -X github.com/sundowndev/phoneinfoga/v2/build.Commit=brew
    ]

    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    assert_match "PhoneInfoga v#{version}-brew", shell_output("#{bin}/phoneinfoga version")
    system "#{bin}/phoneinfoga", "scanners"
    assert_match "given phone number is not valid", shell_output("#{bin}/phoneinfoga scan -n foobar 2>&1", 1)
  end
end
