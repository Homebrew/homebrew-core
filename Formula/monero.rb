class Monero < Formula
  desc "Official Monero wallet and CPU miner"
  homepage "https://www.getmonero.org/"
  url "https://github.com/monero-project/monero.git",
      tag:      "v0.17.1.5",
      revision: "3942a1cd043bb103ca05184057aea5c86e3137e5"
  license "BSD-3-Clause"

  bottle do
    cellar :any
    sha256 "974dfea5ebc07adf056136cd7c36a6a6fee4115b4b7171a65f1254df68f9752a" => :big_sur
    sha256 "f38dbe6c439a09271c947df2fe194c60b4f3d63e701a69287c49bc4abfc3600b" => :catalina
    sha256 "9a6a3484da3bd0015a3df31815091e11af2b3afb1675f64e86277eee894e416c" => :mojave
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "hidapi"
  depends_on "libsodium"
  depends_on "openssl@1.1"
  depends_on "protobuf"
  depends_on "readline"
  depends_on "unbound"
  depends_on "zeromq"

  conflicts_with "wownero", because: "both install a wallet2_api.h header"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"

    # Fix conflict with miniupnpc.
    # This has been reported at https://github.com/monero-project/monero/issues/3862
    rm lib/"libminiupnpc.a"
  end

  plist_options manual: "monerod"

  def plist
    <<~EOS
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
