class Jsvc < Formula
  desc "Wrapper to launch Java applications as daemons"
  homepage "https://commons.apache.org/daemon/jsvc.html"
  url "https://www.apache.org/dyn/closer.lua?path=commons/daemon/source/commons-daemon-1.3.0-src.tar.gz"
  mirror "https://archive.apache.org/dist/commons/daemon/source/commons-daemon-1.3.0-src.tar.gz"
  sha256 "533cd76fe3113d535313c1d8b01ff23caf6babccc699b1a68b4446937cc4474b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "803d721fac307b518b3abb22d398def6e1b23717b5db9143c0341d7412cce24c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "771e112751eb5c424f61c04f9a4aec6c02e0001ce88b400565c7a2b8fce71a51"
    sha256 cellar: :any_skip_relocation, monterey:       "2d13f84d71f0e0fb68e89ee72766ae859a576d339a6875f51bd67eceaaaad5cb"
    sha256 cellar: :any_skip_relocation, big_sur:        "50894019268b0cc6757fb62da6756fbfe92138f79afa4eb363f0e14df81de9d4"
    sha256 cellar: :any_skip_relocation, catalina:       "2e4c9e5eaf94ec1b3f9bc70288ea4dc4459e766dbc0f4df9c018f3bbdbf62456"
    sha256 cellar: :any_skip_relocation, mojave:         "357dc6a1c7e9f7c5e07263e0e9985ed3e2a578e9319289479ca204f7c10efc8d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "69433491ae0f64432cc5235647d041fef5c8afeeef379d97590bc3c3d9ab2f02"
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
