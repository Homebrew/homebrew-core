class Ehco < Formula
  desc "Network relay tool and a typo :)"
  homepage "https://github.com/Ehco1996/ehco"
  license "GPL-3.0-only"
  revision 1
  head "https://github.com/Ehco1996/ehco.git", branch: "master"

  stable do
    url "https://github.com/Ehco1996/ehco/archive/refs/tags/v1.1.2.tar.gz"
    sha256 "064f80a267e22206033c62f5cd61b01172cd7cac532679669474e22993c4884b"

    # go@1.20 build patch, remove in next release
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/cb97010/ehco/1.1.2-go-1.20-build.patch"
      sha256 "47444d6fba83b0f1e02bd42cdc32842f3134ae2a92c029184fd2daa099b25f07"
    end
  end

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+){1,2})$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ce87be268da3599a4b465c714c53bdd48c16175eb0ed116c362d43d42070b5d4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "160dad33d85042932828946aa471dedf9b4e7b7ecc3bb7373028cc41b20e137b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d4a07a01a296fea82d902512cfba70c690dd78316c651498a4f547d9970aa0f6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cf3a460190a6e3a371e2438b652291d87813a3ad330b921fa75c2d572c1805d8"
    sha256 cellar: :any_skip_relocation, sonoma:         "0116095188ec9eaa269a42074efe4cac03e1dee04f1223284996b5468b9d815a"
    sha256 cellar: :any_skip_relocation, ventura:        "cfe40d06528a0a3de3fcf2104798bd16bf1c983336388ad55fa768242656703b"
    sha256 cellar: :any_skip_relocation, monterey:       "07d03ba1e3d42a0d642eb5ae5d1542e4182fb65dbefa19aed3282fae4698ce99"
    sha256 cellar: :any_skip_relocation, big_sur:        "50868b237dec60e966853112729055bbbd905e76a24e2775a4db4ba783137c7d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3569c5b299625b6d80c20fc187a0e48b109a307addda8dd3729e0f82ad519ceb"
  end

  depends_on "go@1.20" => :build

  uses_from_macos "netcat" => :test

  def install
    ldflags = %W[
      -s -w
      -X github.com/Ehco1996/ehco/internal/constant.GitBranch=master
      -X github.com/Ehco1996/ehco/internal/constant.GitRevision=#{tap.user}
      -X github.com/Ehco1996/ehco/internal/constant.BuildTime=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(ldflags: ldflags), "cmd/ehco/main.go"
  end

  test do
    version_info = shell_output("#{bin}/ehco -v 2>&1")
    assert_match "Version=#{version}", version_info

    # run nc server
    nc_port = free_port
    spawn "nc", "-l", nc_port.to_s
    sleep 1

    # run ehco server
    listen_port = free_port
    spawn bin/"ehco", "-l", "localhost:#{listen_port}", "-r", "localhost:#{nc_port}"
    sleep 1

    system "nc", "-z", "localhost", listen_port.to_s
  end
end
