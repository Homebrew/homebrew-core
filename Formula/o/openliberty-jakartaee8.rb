class OpenlibertyJakartaee8 < Formula
  desc "Lightweight open framework for Java (Jakarta EE 8)"
  homepage "https://openliberty.io"
  url "https://public.dhe.ibm.com/ibmdl/export/pub/software/openliberty/runtime/release/23.0.0.7/openliberty-javaee8-23.0.0.7.zip"
  sha256 "5449e0367b24e018571b20610233cac9a79761c25bee89f0b9a3cbd1fa74c230"
  license "EPL-1.0"

  livecheck do
    url "https://openliberty.io/api/builds/data"
    regex(/openliberty[._-]v?(\d+(?:\.\d+)+)\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "be51779df3aeea51a2c22221bf01d2d848afd866f85a9801f91329b6e2f942da"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "be51779df3aeea51a2c22221bf01d2d848afd866f85a9801f91329b6e2f942da"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "be51779df3aeea51a2c22221bf01d2d848afd866f85a9801f91329b6e2f942da"
    sha256 cellar: :any_skip_relocation, ventura:        "be51779df3aeea51a2c22221bf01d2d848afd866f85a9801f91329b6e2f942da"
    sha256 cellar: :any_skip_relocation, monterey:       "be51779df3aeea51a2c22221bf01d2d848afd866f85a9801f91329b6e2f942da"
    sha256 cellar: :any_skip_relocation, big_sur:        "be51779df3aeea51a2c22221bf01d2d848afd866f85a9801f91329b6e2f942da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cb053ddb15684e3a75410de976cd0614faa98bda314a170dbeee6bf6f0022fb6"
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
