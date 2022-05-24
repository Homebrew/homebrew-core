class OpenlibertyJakartaee9 < Formula
  desc "Lightweight open framework for Java (Jakarta EE 9)"
  homepage "https://openliberty.io"
  url "https://public.dhe.ibm.com/ibmdl/export/pub/software/openliberty/runtime/release/22.0.0.5/openliberty-jakartaee9-22.0.0.5.zip"
  sha256 "4bb207fecaf9424224f66908cdbe2127588b8c534b564ada2e7a990cee7d0448"
  license "EPL-1.0"

  livecheck do
    url "https://openliberty.io/api/builds/data"
    regex(/openliberty[._-]v?(\d+(?:\.\d+)+)\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "5f7399f04a4d7964c9f7909d58d806462ecd6186b4e56789b30838a164824c6a"
  end

  depends_on "openjdk"

  def install
    rm_rf Dir["bin/**/*.bat"]

    prefix.install_metafiles
    libexec.install Dir["*"]
    (bin/"openliberty-jakartaee9").write_env_script "#{libexec}/bin/server",
                                                    Language::Java.overridable_java_home_env
  end

  def caveats
    <<~EOS
      The home of Open Liberty Jakarta EE 9 is:
        #{opt_libexec}
    EOS
  end

  test do
    ENV["WLP_USER_DIR"] = testpath

    begin
      system bin/"openliberty-jakartaee9", "start"
      assert_predicate testpath/"servers/.pid/defaultServer.pid", :exist?
    ensure
      system bin/"openliberty-jakartaee9", "stop"
    end

    refute_predicate testpath/"servers/.pid/defaultServer.pid", :exist?
    assert_match "<feature>jakartaee-9.1</feature>", (testpath/"servers/defaultServer/server.xml").read
  end
end
