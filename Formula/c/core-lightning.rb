class CoreLightning < Formula
  desc "Lightning Network implementation focusing on spec compliance and performance"
  homepage "https://github.com/ElementsProject/lightning"
  url "https://github.com/ElementsProject/lightning/releases/download/v24.02.1/clightning-v24.02.1.zip"
  sha256 "733e2b41411a5882d93319883f8575e6959fe33a30e4f0de589ce7e4511a512b"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "1ce531aa2135153a43eb9154cc30904bca8c7a3b3e5285a66b3622afc6257ecf"
    sha256 cellar: :any,                 arm64_ventura:  "42c09ded7e8eda82d2d8717b9984de52ffc848e8d1240580abef7328863996aa"
    sha256 cellar: :any,                 arm64_monterey: "862b37c0d460f2829628341706d29761debac0da32b60855ac5860257f75c8f5"
    sha256 cellar: :any,                 sonoma:         "9fae26ee09696f3a14291201264098d1901a25c370ad0b53f29c32fee4cbf10c"
    sha256 cellar: :any,                 ventura:        "956ccfa48378ee7b5587d2c6daa41fade9b297cd65ec787d3e80dd8299de3ccf"
    sha256 cellar: :any,                 monterey:       "5cb5bd6c0ae906722085b091cd3fcfb7d248c3a37c6dda9a7362fe66cf6f9c7a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6efed1952eafd6849b40a53627789ee1ea6d686ddb2fb853355c4c67c1ad2818"
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
