class Jsvc < Formula
  desc "Wrapper to launch Java applications as daemons"
  homepage "https://commons.apache.org/daemon/jsvc.html"
  url "https://www.apache.org/dyn/closer.lua?path=commons/daemon/source/commons-daemon-1.3.1-src.tar.gz"
  mirror "https://archive.apache.org/dist/commons/daemon/source/commons-daemon-1.3.1-src.tar.gz"
  sha256 "492737a1cb9b09f06366dc941e9084eab0e417b52d0005ac5086bd7d0d601edb"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "15064ef2cbbb172ea40ed6acdf599cf9d26cff8ee28e8d9e045384109f2e3986"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "261ed5fb648619f0f15b9b205be9e94f8c694882cea68c79a168a4b564c96cfb"
    sha256 cellar: :any_skip_relocation, monterey:       "526f7e913702f3820068693a17320a39762f5779f0042dffb75385f6d2074d5c"
    sha256 cellar: :any_skip_relocation, big_sur:        "52a52c0bb34c8368ff6724d0253a6dd35e1f923bf763e75480917c3d7714a5d4"
    sha256 cellar: :any_skip_relocation, catalina:       "033eeda00f9c5fcaddc47a6f1f49d3fc47330e7a6230566088133006aeb71e10"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "10aa62aafdedde51dcc21d8da77e7789284da6bbd27989cd73b69cf3f676c194"
  end

  depends_on "openjdk"

  def install
    prefix.install %w[NOTICE.txt LICENSE.txt RELEASE-NOTES.txt]

    cd "src/native/unix" do
      system "./configure", "--with-java=#{Formula["openjdk"].opt_prefix}"
      system "make"

      libexec.install "jsvc"
      (bin/"jsvc").write_env_script libexec/"jsvc", Language::Java.overridable_java_home_env
    end
  end

  test do
    output = shell_output("#{bin}/jsvc -help")
    assert_match "jsvc (Apache Commons Daemon)", output
  end
end
