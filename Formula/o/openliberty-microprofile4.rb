class OpenlibertyMicroprofile4 < Formula
  desc "Lightweight open framework for Java (Micro Profile 4)"
  homepage "https://openliberty.io"
  url "https://public.dhe.ibm.com/ibmdl/export/pub/software/openliberty/runtime/release/26.0.0.3/openliberty-microProfile4-26.0.0.3.zip"
  sha256 "f838a95121d28469cd277a68542de9769105c4e74e79c84e14276e32d9af6dca"
  license "EPL-1.0"

  livecheck do
    url "https://openliberty.io/api/builds/data"
    regex(/openliberty[._-]v?(\d+(?:\.\d+)+)\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "3286f43e2e7266b2829b28ca43d10ddf676aaba6a656584c4580cd338be15fcc"
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
