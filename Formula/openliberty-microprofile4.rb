class OpenlibertyMicroprofile4 < Formula
  desc "Lightweight open framework for Java (Micro Profile 4)"
  homepage "https://openliberty.io"
  url "https://public.dhe.ibm.com/ibmdl/export/pub/software/openliberty/runtime/release/2021-10-19_1900/openliberty-microProfile4-21.0.0.11.zip"
  sha256 "9da317fe28f8cf66009075ab5d114de362a170f2fcef911b2434d5192f50f264"
  license "EPL-1.0"

  livecheck do
    url "https://openliberty.io/api/builds/data"
    regex(/openliberty[._-]v?(\d+(?:\.\d+)+)\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "5400228110f6fe508f36798890f01620e677971584ae7766ed95cad08e024513"
    sha256 cellar: :any_skip_relocation, big_sur:       "5400228110f6fe508f36798890f01620e677971584ae7766ed95cad08e024513"
    sha256 cellar: :any_skip_relocation, catalina:      "5400228110f6fe508f36798890f01620e677971584ae7766ed95cad08e024513"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "014d116be6a932aaa48809f614aad06b7ca76a4b07e575a1b7fb08a62f02dea2"
    sha256 cellar: :any_skip_relocation, all:           "02334e27f319ab80dd5f128a2e3e92bbdac1554dc49422f4b3d449efd1f7161d"
  end

  depends_on "openjdk"

  def install
    rm_rf Dir["bin/**/*.bat"]

    prefix.install_metafiles
    libexec.install Dir["*"]
    (bin/"openliberty-microprofile4").write_env_script "#{libexec}/bin/server",
                                                       Language::Java.overridable_java_home_env
  end

  def caveats
    <<~EOS
      The home of Open Liberty Micro Profile 4 is:
        #{opt_libexec}
    EOS
  end

  test do
    ENV["WLP_USER_DIR"] = testpath

    begin
      system bin/"openliberty-microprofile4", "start"
      assert_predicate testpath/"servers/.pid/defaultServer.pid", :exist?
    ensure
      system bin/"openliberty-microprofile4", "stop"
    end

    refute_predicate testpath/"servers/.pid/defaultServer.pid", :exist?
    assert_match "<feature>microProfile-4.1</feature>", (testpath/"servers/defaultServer/server.xml").read
  end
end
