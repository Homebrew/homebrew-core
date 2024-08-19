class OpenlibertyJakartaee8 < Formula
  desc "Lightweight open framework for Java (Jakarta EE 8)"
  homepage "https://openliberty.io"
  url "https://public.dhe.ibm.com/ibmdl/export/pub/software/openliberty/runtime/release/24.0.0.7/openliberty-javaee8-24.0.0.7.zip"
  sha256 "9080788909e4fc4c6e395e3ec380bebeefbb28339c02ddf0c69b681e5a3e8581"
  license "EPL-1.0"

  livecheck do
    url "https://openliberty.io/api/builds/data"
    regex(/openliberty[._-]v?(\d+(?:\.\d+)+)\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3d4560266b5a79a53aa0bda43041fa7ff2139e2eabc100a2c41d124429042d88"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3d4560266b5a79a53aa0bda43041fa7ff2139e2eabc100a2c41d124429042d88"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3d4560266b5a79a53aa0bda43041fa7ff2139e2eabc100a2c41d124429042d88"
    sha256 cellar: :any_skip_relocation, sonoma:         "3d4560266b5a79a53aa0bda43041fa7ff2139e2eabc100a2c41d124429042d88"
    sha256 cellar: :any_skip_relocation, ventura:        "3d4560266b5a79a53aa0bda43041fa7ff2139e2eabc100a2c41d124429042d88"
    sha256 cellar: :any_skip_relocation, monterey:       "3d4560266b5a79a53aa0bda43041fa7ff2139e2eabc100a2c41d124429042d88"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9eae33ba6474d06594fbfef0a109abab0da876feacf25a57da68b653f651f8d4"
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
      assert_predicate testpath/"servers/.pid/defaultServer.pid", :exist?
    ensure
      system bin/"openliberty-jakartaee8", "stop"
    end

    refute_predicate testpath/"servers/.pid/defaultServer.pid", :exist?
    assert_match "<feature>javaee-8.0</feature>", (testpath/"servers/defaultServer/server.xml").read
  end
end
