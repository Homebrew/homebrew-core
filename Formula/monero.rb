class Monero < Formula
  desc "Official monero wallet and cpu miner"
  homepage "https://getmonero.org/"
  url "https://github.com/monero-project/monero.git",
      :tag      => "v0.15.0.1",
      :revision => "6def88ad405b39f632a91afa3aacbb92ecc63c1f"

  bottle do
    cellar :any
    sha256 "9692a78382ea9a4c4d12e43c228c1789696d8fb1a3d137bd29b9cdce8b2e532a" => :catalina
    sha256 "350e30d0dc79742c442f44e5f80621d75f502ea044337422d4e6e9333bf3d084" => :mojave
    sha256 "65ebae03a8a85a9d406f19eabfba28e84cb32e36b8af51a06a2d23846eb9d0f0" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "libsodium"
  depends_on "openssl@1.1"
  depends_on "readline"
  depends_on "unbound"
  depends_on "zeromq"

  resource "cppzmq" do
    url "https://github.com/zeromq/cppzmq/archive/v4.3.0.tar.gz"
    sha256 "27d1f56406ba94ee779e639203218820975cf68174f92fbeae0f645df0fcada4"
  end

  def install
    (buildpath/"cppzmq").install resource("cppzmq")
    system "cmake", ".", "-DZMQ_INCLUDE_PATH=#{buildpath}/cppzmq",
                         "-DReadline_ROOT_DIR=#{Formula["readline"].opt_prefix}",
                         *std_cmake_args
    system "make", "install"

    # Avoid conflicting with miniupnpc
    # Reported upstream 25 May 2018 https://github.com/monero-project/monero/issues/3862
    rm lib/"libminiupnpc.a"
    rm_rf include/"miniupnpc"
  end

  plist_options :manual => "monerod"

  def plist; <<~EOS
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>Label</key>
      <string>#{plist_name}</string>
      <key>ProgramArguments</key>
      <array>
        <string>#{opt_bin}/monerod</string>
        <string>--non-interactive</string>
      </array>
      <key>RunAtLoad</key>
      <true/>
    </dict>
    </plist>
  EOS
  end

  test do
    cmd = "yes '' | #{bin}/monero-wallet-cli --restore-deterministic-wallet " \
      "--password brew-test --restore-height 1 --generate-new-wallet wallet " \
      "--electrum-seed 'baptism cousin whole exquisite bobsled fuselage left " \
      "scoop emerge puzzled diet reinvest basin feast nautical upon mullet " \
      "ponies sixteen refer enhanced maul aztec bemused basin'" \
      "--command address"
    address = "4BDtRc8Ym9wGzx8vpkQQvpejxBNVpjEmVBebBPCT4XqvMxW3YaCALFraiQibejyMAxUXB5zqn4pVgHVm3JzhP2WzVAJDpHf"
    assert_equal address, shell_output(cmd).lines.last.split[1]
  end
end
