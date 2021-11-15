class OpenlibertyJakartaee8 < Formula
  desc "Lightweight open framework for Java (Jakarta EE 8)"
  homepage "https://openliberty.io"
  url "https://public.dhe.ibm.com/ibmdl/export/pub/software/openliberty/runtime/release/2021-10-19_1900/openliberty-javaee8-21.0.0.11.zip"
  sha256 "1365a0fc00e1ac2d28ecea382b03535dd40ed4449d6ccb3c88617f4cb3c40051"
  license "EPL-1.0"

  livecheck do
    url "https://openliberty.io/api/builds/data"
    regex(/openliberty[._-]v?(\d+(?:\.\d+)+)\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "9edeadbe31f910b8a7c685b56cd6881aa22113ca7645c22d7ed544b8249eab5d"
    sha256 cellar: :any_skip_relocation, big_sur:       "9edeadbe31f910b8a7c685b56cd6881aa22113ca7645c22d7ed544b8249eab5d"
    sha256 cellar: :any_skip_relocation, catalina:      "9edeadbe31f910b8a7c685b56cd6881aa22113ca7645c22d7ed544b8249eab5d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c3659de73d710f70e70d52fdcbdefcc2270a1b24ab9a690483aaf573626106f6"
    sha256 cellar: :any_skip_relocation, all:           "629f99205e46f325880689e2617822813f7bf42490f9423554620c3aeef5302a"
  end

  depends_on "openjdk"

  def install
    rm_rf Dir["bin/**/*.bat"]

    prefix.install_metafiles
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
      assert_predicate testpath/"servers/.pid/defaultServer.pid", :exist?
    ensure
      system bin/"openliberty-jakartaee8", "stop"
    end

    refute_predicate testpath/"servers/.pid/defaultServer.pid", :exist?
    assert_match "<feature>javaee-8.0</feature>", (testpath/"servers/defaultServer/server.xml").read
  end
end
