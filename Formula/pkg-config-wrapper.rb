class PkgConfigWrapper < Formula
  desc "Easier way to include C code in your Go program"
  homepage "https://github.com/influxdata/pkg-config"
  url "https://github.com/influxdata/pkg-config/archive/v0.2.12.tar.gz"
  sha256 "23b2ed6a2f04d42906f5a8c28c8d681d03d47a1c32435b5df008adac5b935f1a"
  license "MIT"
  head "https://github.com/influxdata/pkg-config.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cf1a133af5a0736c339ca03ca1e55d460835c137c9c3430a4150f04addef59ec"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "73e0e3154ccc02d0fccf377426069944d80b112e671471ea93ab852001b3cf45"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0859f0c9900ff75118937dfb5fb4c819ea946cf85b28c26e00ed17471688da2b"
    sha256 cellar: :any_skip_relocation, ventura:        "51f080f177cfe4b81a5aa5c19921db19c2792827a873c4a0432b882faf26e848"
    sha256 cellar: :any_skip_relocation, monterey:       "dfaba417b6359e63e6a16426f0cbf3368ed111294dadfd63f9b89435c2612003"
    sha256 cellar: :any_skip_relocation, big_sur:        "68d05c1c5e5310b4bd7a68d6aaad6cedf9190935a47513be58dd85e06909a556"
    sha256 cellar: :any_skip_relocation, catalina:       "d1a3561a851957ec62856bc5a1407501976c48fe54ef290abe102a3d357207d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "61e696135462df386455fd1d33703e5a96f0830eaaee28cc7932c8cd4d93c2f6"
  end

  depends_on "go" => :build
  depends_on "pkg-config"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match "Found pkg-config executable", shell_output(bin/"pkg-config-wrapper 2>&1", 1)
  end
end
