class OpenlibertyWebprofile8 < Formula
  desc "Lightweight open framework for Java (Jakarta EE Web Profile 8)"
  homepage "https://openliberty.io"
  url "https://public.dhe.ibm.com/ibmdl/export/pub/software/openliberty/runtime/release/2021-10-19_1900/openliberty-webProfile8-21.0.0.11.zip"
  sha256 "1bb90d605ecd464b1cddb72ff788fda74d5c5a7cca2e6728021fb19bf2cfa231"
  license "EPL-1.0"

  livecheck do
    url "https://openliberty.io/api/builds/data"
    regex(/openliberty[._-]v?(\d+(?:\.\d+)+)\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "a72a9295f548ba7ff0639c54d0a9af282fec42f0f0d3755dd2903f038ea383c9"
    sha256 cellar: :any_skip_relocation, big_sur:       "a72a9295f548ba7ff0639c54d0a9af282fec42f0f0d3755dd2903f038ea383c9"
    sha256 cellar: :any_skip_relocation, catalina:      "a72a9295f548ba7ff0639c54d0a9af282fec42f0f0d3755dd2903f038ea383c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "14ccb8393dc804aed211a40512d35604f47ada03faa7cba1f6dac77fd9dd7d2f"
    sha256 cellar: :any_skip_relocation, all:           "bbb45837c8fa8cafb7400e848e4988ea1578ca9245e92ee244ba9b1b5a3c3eaf"
  end

  depends_on "openjdk"

  def install
    rm_rf Dir["bin/**/*.bat"]

    prefix.install_metafiles
    libexec.install Dir["*"]
    (bin/"openliberty-webprofile8").write_env_script "#{libexec}/bin/server",
                                                     Language::Java.overridable_java_home_env
  end

  def caveats
    <<~EOS
      The home of Open Liberty Jakarta EE Web Profile 8 is:
        #{opt_libexec}
    EOS
  end

  test do
    ENV["WLP_USER_DIR"] = testpath

    begin
      system bin/"openliberty-webprofile8", "start"
      assert_predicate testpath/"servers/.pid/defaultServer.pid", :exist?
    ensure
      system bin/"openliberty-webprofile8", "stop"
    end

    refute_predicate testpath/"servers/.pid/defaultServer.pid", :exist?
    assert_match "<feature>webProfile-8.0</feature>", (testpath/"servers/defaultServer/server.xml").read
  end
end
