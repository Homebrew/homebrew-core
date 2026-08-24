class OpenlibertyMicroprofile4 < Formula
  desc "Lightweight open framework for Java (Micro Profile 4)"
  homepage "https://openliberty.io"
  url "https://public.dhe.ibm.com/ibmdl/export/pub/software/openliberty/runtime/release/26.0.0.8/openliberty-microProfile4-26.0.0.8.zip"
  sha256 "e321195aeb3e4cd7b3e103ac74f036c2992014096c7df06f4e1b8f3cec7016cc"
  license "EPL-1.0"

  livecheck do
    url "https://openliberty.io/api/builds/data"
    regex(/openliberty[._-]v?(\d+(?:\.\d+)+)\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "6f49588157545b1849b5ff4ef58c64293cf6479bf0501c136e4750511c1d40ae"
  end

  depends_on "openjdk"

  def install
    rm_r(Dir["bin/**/*.bat"])

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
      assert_path_exists testpath/"servers/.pid/defaultServer.pid"
    ensure
      system bin/"openliberty-microprofile4", "stop"
    end

    refute_path_exists testpath/"servers/.pid/defaultServer.pid"
    assert_match "<feature>microProfile-4.1</feature>", (testpath/"servers/defaultServer/server.xml").read
  end
end
