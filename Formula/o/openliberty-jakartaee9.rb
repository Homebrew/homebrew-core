class OpenlibertyJakartaee9 < Formula
  desc "Lightweight open framework for Java (Jakarta EE 9)"
  homepage "https://openliberty.io"
  url "https://public.dhe.ibm.com/ibmdl/export/pub/software/openliberty/runtime/release/23.0.0.2/openliberty-jakartaee9-23.0.0.2.zip"
  sha256 "32f267a1dceae26d9349deb252581ff7e33e2b1a6f324b9f430ad23b16efe67e"
  license "EPL-1.0"

  livecheck do
    url "https://openliberty.io/api/builds/data"
    regex(/openliberty[._-]jakartaee9[._-]v?(\d+(?:\.\d+)+)\.zip/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "69434015835d5c9c2ca412ea3c6fbc6c96cc09f85a933581fe162b8d1f12a327"
  end

  depends_on "openjdk"

  def install
    rm_r(Dir["bin/**/*.bat"])

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
      assert_path_exists testpath/"servers/.pid/defaultServer.pid"
    ensure
      system bin/"openliberty-jakartaee9", "stop"
    end

    refute_path_exists testpath/"servers/.pid/defaultServer.pid"
    assert_match "<feature>jakartaee-9.1</feature>", (testpath/"servers/defaultServer/server.xml").read
  end
end
