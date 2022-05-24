class OpenlibertyWebprofile9 < Formula
  desc "Lightweight open framework for Java (Jakarta EE Web Profile 9)"
  homepage "https://openliberty.io"
  url "https://public.dhe.ibm.com/ibmdl/export/pub/software/openliberty/runtime/release/22.0.0.5/openliberty-webProfile9-22.0.0.5.zip"
  sha256 "a1ffbd5ad92c7508d9dabeec7e1e4501b55c68b671923253d4a5b550c4ff10e3"
  license "EPL-1.0"

  livecheck do
    url "https://openliberty.io/api/builds/data"
    regex(/openliberty[._-]v?(\d+(?:\.\d+)+)\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d163856b076cef2c60d21665f30518491fef50c80755bcc6aeea3b9e4e6c171b"
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
