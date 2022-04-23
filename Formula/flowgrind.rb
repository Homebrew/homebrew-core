class Flowgrind < Formula
  desc "TCP measurement tool, similar to iperf or netperf"
  homepage "https://launchpad.net/flowgrind"
  url "https://launchpad.net/flowgrind/trunk/flowgrind-0.8.0/+download/flowgrind-0.8.0.tar.bz2"
  sha256 "2e8b58fc919bb1dae8f79535e21931336355b4831d8b5bf75cf43eacd1921d04"
  revision 4

  livecheck do
    url :stable
    regex(%r{<div class="version">\s*Latest version is flowgrind[._-]v?(\d+(?:\.\d+)+)\s*</div>}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "f1a52d1f915547526cc01ea5be8907ff9580919ea3d838c8bfb16bf9cd0a4675"
    sha256 cellar: :any,                 big_sur:       "7deade98f4d2b56a16b700d708e014cc9d66224f429629c646e0c45dbc659759"
    sha256 cellar: :any,                 catalina:      "b6351fe504faa1294e6f280d30bdaeeda2fe93e222146503c8f06e53ab7b57cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a103a74d717b0944d8e3849414c122d9e0cd9b071c7305bf2a8f5ea6b7003086"
  end

  depends_on "gsl"
  depends_on "xmlrpc-c"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/flowgrind", "--version"
  end
end
