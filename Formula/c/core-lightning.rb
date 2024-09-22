class CoreLightning < Formula
  desc "Lightning Network implementation focusing on spec compliance and performance"
  homepage "https://github.com/ElementsProject/lightning"
  url "https://github.com/ElementsProject/lightning/releases/download/v24.08.1/clightning-v24.08.1.zip"
  sha256 "d992af84dbb319fb4ac127663241cec04f54108e44c27e471d2cb2654702c01e"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_sequoia: "0e87df26d10596226cf0773c3a89869aae29f8c6341065b173805e79b4dde5af"
    sha256 cellar: :any, arm64_sonoma:  "a5a92f36df8ea4b81a09852e77bab0a6911b0f13518bab787b24325804aa8cf6"
    sha256 cellar: :any, arm64_ventura: "b19deb168705a6a20d449a04bffc6ef0f0515192c813660adb7617856349260f"
    sha256               sonoma:        "2a4303879db683387b91bd449f1e2c84c70609e6c747e19fe14d1eddba86b705"
    sha256               ventura:       "8c35066c7fd414873f7d1aae4b3d89a187df2c425f32137bef8c15aac21778bc"
    sha256               x86_64_linux:  "e79e6b97f384373f738d902097292812edf14eca24a10e7458be241c02d21ab5"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "gettext" => :build
  depends_on "gnu-sed" => :build
  depends_on "jq" => :build
  depends_on "libtool" => :build
  depends_on "lowdown" => :build
  depends_on "pkg-config" => :build
  depends_on "poetry" => :build
  depends_on "protobuf" => :build
  depends_on "bitcoin"
  depends_on "gmp"
  depends_on "libsodium"

  uses_from_macos "python"
  uses_from_macos "sqlite"
  uses_from_macos "zlib"

  def install
    rm_r(buildpath/"external/lowdown")
    system "poetry", "install", "--only=main"
    system "./configure", "--prefix=#{prefix}"
    system "poetry", "run", "make", "install"
  end

  test do
    cmd = "#{bin}/lightningd --daemon --network regtest --log-file lightningd.log"
    if OS.mac? && Hardware::CPU.arm?
      lightningd_output = shell_output("#{cmd} 2>&1", 10)
      assert_match "lightningd: Could not run #{bin}/lightning_channeld: No such file or directory", lightningd_output
    else
      lightningd_output = shell_output("#{cmd} 2>&1", 1)
      assert_match "Could not connect to bitcoind using bitcoin-cli. Is bitcoind running?", lightningd_output
    end

    lightningcli_output = shell_output("#{bin}/lightning-cli --network regtest getinfo 2>&1", 2)
    assert_match "lightning-cli: Connecting to 'lightning-rpc': No such file or directory", lightningcli_output
  end
end
