class OpenlibertyJakartaee8 < Formula
  desc "Lightweight open framework for Java (Jakarta EE 8)"
  homepage "https://openliberty.io"
  url "https://public.dhe.ibm.com/ibmdl/export/pub/software/openliberty/runtime/release/26.0.0.6/openliberty-javaee8-26.0.0.6.zip"
  sha256 "d0f2d78f4d01ceaafb27d0235a750fe337904c9fb6a1ffb6b2c860abd509b9f0"
  license "EPL-1.0"

  livecheck do
    url "https://openliberty.io/api/builds/data"
    regex(/openliberty[._-]v?(\d+(?:\.\d+)+)\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c2b6783e2dca127bb94c5cedd25c1f1e4988f86a3de48d7214ea8905841b7e10"
  end

  depends_on "openjdk"

  def install
    rm_r(Dir["bin/**/*.bat"])

    libexec.install Dir["*"]
    (bin/"openliberty-jakartaee8").write_env_script "#{libexec}/bin/server",
                                                    Language::Java.overridable_java_home_env
  end

  def caveats
    <<~EOS
      The home of Open Liberty Jakarta EE 8 is:
        #{opt_libexec}
    EOS
  end

  test do
    ENV["WLP_USER_DIR"] = testpath

    begin
      system bin/"openliberty-jakartaee8", "start"
      assert_path_exists testpath/"servers/.pid/defaultServer.pid"
    ensure
      system bin/"openliberty-jakartaee8", "stop"
    end

    refute_path_exists testpath/"servers/.pid/defaultServer.pid"
    assert_match "<feature>javaee-8.0</feature>", (testpath/"servers/defaultServer/server.xml").read
  end
end
