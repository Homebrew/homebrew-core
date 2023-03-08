class OpenlibertyWebprofile9 < Formula
  desc "Lightweight open framework for Java (Jakarta EE Web Profile 9)"
  homepage "https://openliberty.io"
  url "https://public.dhe.ibm.com/ibmdl/export/pub/software/openliberty/runtime/release/23.0.0.2/openliberty-webProfile9-23.0.0.2.zip"
  sha256 "dca56a1db905d1176af7ba3a4ad779355429da7b676d7f984a41d228b3fccd9c"
  license "EPL-1.0"

  livecheck do
    url "https://openliberty.io/api/builds/data"
    regex(/openliberty[._-]v?(\d+(?:\.\d+)+)\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fe51c1d2d90bbb0a840a0485e6fc030ef843611cdfe7c7d623110a575189317c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f3a0f21197160397e9a5a86a6282433f417320ee2315d052f5cfab3e1e9886a9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1abafd5698ee6454fd70ddcfb67de7a4f1858284c76f33503bea238f8175abc2"
    sha256 cellar: :any_skip_relocation, ventura:        "b4c7e5bf6cbf7f6c723eb2b8c057de39751634db7fec977db5fab8df250a68b4"
    sha256 cellar: :any_skip_relocation, monterey:       "928bf34ccbd2a414cabda6063e026e5eb0c650e49e77bb7febcf204ad8e3bfd8"
    sha256 cellar: :any_skip_relocation, big_sur:        "dc3280466583414c6f9d4da9310eacc26023d8a54f21ee4f3b88112772e04b35"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "631d70d64568906515d045d9bb490af4297a1ef0dc8d4d778aad88bf0ea74674"
  end

  depends_on "openjdk"

  def install
    rm_rf Dir["bin/**/*.bat"]

    prefix.install_metafiles
    libexec.install Dir["*"]
    (bin/"openliberty-webprofile9").write_env_script "#{libexec}/bin/server",
                                                     Language::Java.overridable_java_home_env
  end

  def caveats
    <<~EOS
      The home of Open Liberty Jakarta EE Web Profile 9 is:
        #{opt_libexec}
    EOS
  end

  test do
    ENV["WLP_USER_DIR"] = testpath

    begin
      system bin/"openliberty-webprofile9", "start"
      assert_predicate testpath/"servers/.pid/defaultServer.pid", :exist?
    ensure
      system bin/"openliberty-webprofile9", "stop"
    end

    refute_predicate testpath/"servers/.pid/defaultServer.pid", :exist?
    assert_match "<feature>webProfile-9.1</feature>", (testpath/"servers/defaultServer/server.xml").read
  end
end
