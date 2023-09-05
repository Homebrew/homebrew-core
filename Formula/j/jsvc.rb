class Jsvc < Formula
  desc "Wrapper to launch Java applications as daemons"
  homepage "https://commons.apache.org/daemon/jsvc.html"
  url "https://www.apache.org/dyn/closer.lua?path=commons/daemon/source/commons-daemon-1.3.4-src.tar.gz"
  mirror "https://archive.apache.org/dist/commons/daemon/source/commons-daemon-1.3.4-src.tar.gz"
  sha256 "df4849d05e5816610e67821883f4fc1e11724a0bb8b78b84b21edd5039ecebbe"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "67b2f6ca19fc32e880da2d1632b936b27e9b71b0b6e4dc07807b59116a81ac6c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f00cc40d1a1ac56d177289136f4f7242d3782148f821ffa423dbbd2ae00c23b9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "52a5db040326b5d1bd320d32c2a46cb124ff2be717b2a43213c2dbc86a1ed4a2"
    sha256 cellar: :any_skip_relocation, ventura:        "8b619e88b09aa9fe51aa6dd590fa8086e94a68311b648abb143d8494fc5895cc"
    sha256 cellar: :any_skip_relocation, monterey:       "45ff39a69977dd40e9ba66f0652e7a5c751fe158a300171c3dd6c4a59511a240"
    sha256 cellar: :any_skip_relocation, big_sur:        "f7a618038934966325dfad9c2a818998a7164a3021f6aa7a2d826d98afb1f6e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d3a9cc26e81c7dee78070536a0fd2e0beb4ac660a79f3a7cb412b596b0d67648"
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
