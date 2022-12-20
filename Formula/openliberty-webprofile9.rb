class OpenlibertyWebprofile9 < Formula
  desc "Lightweight open framework for Java (Jakarta EE Web Profile 9)"
  homepage "https://openliberty.io"
  url "https://public.dhe.ibm.com/ibmdl/export/pub/software/openliberty/runtime/release/22.0.0.13/openliberty-webProfile9-22.0.0.13.zip"
  sha256 "f5279936887f08d1c976126377ace27fd5b5c3d76188c3da705b734f1e6aa121"
  license "EPL-1.0"

  livecheck do
    url "https://openliberty.io/api/builds/data"
    regex(/openliberty[._-]v?(\d+(?:\.\d+)+)\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "a1fa79a56c5fe645ac235b271485740c1ed3dac2546d0377ed3e4cbacc3f0b45"
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
