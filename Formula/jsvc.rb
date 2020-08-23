class Jsvc < Formula
  desc "Wrapper to launch Java applications as daemons"
  homepage "https://commons.apache.org/daemon/jsvc.html"
  url "https://www.apache.org/dyn/closer.lua?path=commons/daemon/source/commons-daemon-1.2.2-src.tar.gz"
  mirror "https://archive.apache.org/dist/commons/daemon/source/commons-daemon-1.2.2-src.tar.gz"
  sha256 "ebd9d50989ee2009cc83f501e6793ad5978672ecea97be5198135a081a8aac71"
  license "Apache-2.0"
  revision 2

  bottle do
    cellar :any_skip_relocation
    sha256 "d394dda87f296a36c2e39b8954db0f8496285dfdf94cd07bf236fec7df1edf3d" => :catalina
    sha256 "bea286d1d134d91bc5e7a8596cbf015f29c09e6ba4bef9f356e51dfa8777fb9d" => :mojave
    sha256 "73b144be1f0b0dabfabb254515d250ce310405ca8c975e072109c75e5f6debd5" => :high_sierra
  end

  depends_on "openjdk"

  def install
    prefix.install %w[NOTICE.txt LICENSE.txt RELEASE-NOTES.txt]

    cd "src/native/unix" do
      system "./configure", "--with-java=#{Formula["openjdk"].opt_prefix}"
      system "make"

      libexec.install "jsvc"
      (bin/"jsvc").write_env_script libexec/"jsvc", JAVA_HOME: "${JAVA_HOME:-#{Formula["openjdk"].opt_prefix}}"
    end
  end

  test do
    output = shell_output("#{bin}/jsvc -help")
    assert_match "jsvc (Apache Commons Daemon)", output
  end
end
