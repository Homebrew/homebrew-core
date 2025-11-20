class OpenlibertyMicroprofile4 < Formula
  desc "Lightweight open framework for Java (Micro Profile 4)"
  homepage "https://openliberty.io"
  url "https://public.dhe.ibm.com/ibmdl/export/pub/software/openliberty/runtime/release/25.0.0.11/openliberty-microProfile4-25.0.0.11.zip"
  sha256 "a05ee14e4f257a1f8e5cd93d9578eb888c5ea14fcba8e353a180c33c546e6b13"
  license "EPL-1.0"

  livecheck do
    url "https://openliberty.io/api/builds/data"
    regex(/openliberty[._-]v?(\d+(?:\.\d+)+)\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "9a7319079ea0eecbf13cff60623b540612d1e0078a506a20c7cac6dad1c7ccce"
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
