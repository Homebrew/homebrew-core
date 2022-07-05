class OpenlibertyJakartaee8 < Formula
  desc "Lightweight open framework for Java (Jakarta EE 8)"
  homepage "https://openliberty.io"
  url "https://public.dhe.ibm.com/ibmdl/export/pub/software/openliberty/runtime/release/22.0.0.7/openliberty-javaee8-22.0.0.7.zip"
  sha256 "9a65980ae99ac286baa9da9d664e4cdf84df67c608431f4deb07452a146ce526"
  license "EPL-1.0"

  livecheck do
    url "https://openliberty.io/api/builds/data"
    regex(/openliberty[._-]v?(\d+(?:\.\d+)+)\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e60fe1622afadf95f524c8ab1134bfaa555a9650a4d1c59be422f42bff568031"
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
