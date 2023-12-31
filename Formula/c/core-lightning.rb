class CoreLightning < Formula
  desc "Lightning Network implementation focusing on spec compliance and performance"
  homepage "https://github.com/ElementsProject/lightning"
  url "https://github.com/ElementsProject/lightning/releases/download/v23.11.2/clightning-v23.11.2.zip"
  sha256 "9f5fbd438f7737f379b2beec569ce139bb5b2a911e8ec35452185b60fba4bde8"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "edf147abb323c194ef466687a2ba97755a9c0fba6282e85fd760d722750063e2"
    sha256 cellar: :any,                 arm64_ventura:  "2a9d5bb813da3ae55991b01abcc5454eaacd4cb3d75278193fada5be2088f5f8"
    sha256 cellar: :any,                 arm64_monterey: "ca252203b50e9f10fb09b4d78a5cc156868d600adeb30349ddf0d60dc7bc8522"
    sha256 cellar: :any,                 sonoma:         "9d3d23087eeca37e2bfab25ba9db9f301cdbf9b6c5cefa9e58499d6bb4e72891"
    sha256 cellar: :any,                 ventura:        "6ec88da258f2758ea4bb587fcc44d92efbdb79b3abd72aa4cb7cadb35ad2dc6e"
    sha256 cellar: :any,                 monterey:       "6cec654fa0d74a009480f73a56790ccb73dee4b93a7669827134f92ac1e8f5d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cda16201c173190f635a4aaea36a0f9f9fdd4b55bfb77eec45a153959686dcc9"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "gettext" => :build
  depends_on "gnu-sed" => :build
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

  def install
    (buildpath/"external/lowdown").rmtree
    system "poetry", "install", "--only=main"
    system "./configure", "--prefix=#{prefix}"
    system "poetry", "run", "make", "install"
  end

  test do
    cmd = "#{bin}/lightningd --daemon --network regtest --log-file lightningd.log"
    if OS.mac? && Hardware::CPU.arm?
      lightningd_output = shell_output("#{cmd} 2>&1", 10)
      assert_match "lightningd: Could not run /lightning_channeld: No such file or directory", lightningd_output
    else
      lightningd_output = shell_output("#{cmd} 2>&1", 1)
      assert_match "Could not connect to bitcoind using bitcoin-cli. Is bitcoind running?", lightningd_output
    end

    lightningcli_output = shell_output("#{bin}/lightning-cli --network regtest getinfo 2>&1", 2)
    assert_match "lightning-cli: Connecting to 'lightning-rpc': No such file or directory", lightningcli_output
  end
end
