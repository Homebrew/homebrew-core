class Iodine < Formula
  desc "Tunnel IPv4 traffic through a DNS server"
  homepage "https://code.kryo.se/iodine"
  url "https://github.com/yarrick/iodine/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "ffc7a58cdde390a01580f4cfc78c446b0965bcb719bde2c68c5e0c27345a8dfc"
  license "ISC"
  head "https://github.com/yarrick/iodine.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "827ce27290d1b28b1b44fcdb35546eb8b07180a82e8bbee75b4c0d199d47c073"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "78df44a424d8357cd348a96c8a3f87502229b37e8871687bf39e246ea02327fc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6137123041fc9cc12bfb1ab7b5c89db1df5a8a53c46005894ed3a2928cfd0ed2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7d366cab32fff89cfe558c7b03fdf36931a100e2834e6d830a642cb4517eb5e0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c56442257c490693ec92dce6ecf8b579c630460843e1bae51f46f48116a7e316"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6d07879633a49ec8f6dcaf65514c71409acdc9b9a92b05872ed02581ddadb999"
    sha256 cellar: :any_skip_relocation, sonoma:         "ec5682669fd55f55ea306f36d07d84cb69b19bf6fd295e18b3d161a4c32f43ef"
    sha256 cellar: :any_skip_relocation, ventura:        "e1162e6eb9ee5c0579216e80af32079d36adde37fe4653fb6da34a58d54e7c3c"
    sha256 cellar: :any_skip_relocation, monterey:       "297d884daa963973050eb436c9727c850ffce5627a33310bd159e7e13c6c8483"
    sha256 cellar: :any_skip_relocation, big_sur:        "fe1f5e48bcc20c66d29ce945f72d7879ba59eec5af18b3fd46ac3c21c40c6319"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "7878240547b0427b4bb82fdb7062c995362a540e48c87fb97c5b5b81022514b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eef2dd9635b68cd36d2d7e3d1225d0644205250b5600874ad381d8b94a7a5b06"
  end

  depends_on "cmake" => :build

  uses_from_macos "zlib"

  def install
    system "make", "prefix=#{prefix}", "install"
  end

  test do
    # iodine and iodined require being run as root. Match on the non-root error text, which is printed to
    # stderr, as a successful test
    assert_match("iodine: Run as root and you'll be happy.", pipe_output("#{sbin}/iodine google.com 2>&1"))
    assert_match("iodined: Run as root and you'll be happy.", pipe_output("#{sbin}/iodined google.com 2>&1"))
  end
end
