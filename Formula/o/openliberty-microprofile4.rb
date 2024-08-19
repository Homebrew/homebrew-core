class OpenlibertyMicroprofile4 < Formula
  desc "Lightweight open framework for Java (Micro Profile 4)"
  homepage "https://openliberty.io"
  url "https://public.dhe.ibm.com/ibmdl/export/pub/software/openliberty/runtime/release/24.0.0.7/openliberty-microProfile4-24.0.0.7.zip"
  sha256 "c4f4635021cec0f6003886be9c0c0687629cdec5416079271cb9ebabcf6b158d"
  license "EPL-1.0"

  livecheck do
    url "https://openliberty.io/api/builds/data"
    regex(/openliberty[._-]v?(\d+(?:\.\d+)+)\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9c6d8457f13e277e86b0559eca4f21d788f791c4b72dc632c679e6d0df1e0a41"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9c6d8457f13e277e86b0559eca4f21d788f791c4b72dc632c679e6d0df1e0a41"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9c6d8457f13e277e86b0559eca4f21d788f791c4b72dc632c679e6d0df1e0a41"
    sha256 cellar: :any_skip_relocation, sonoma:         "9c6d8457f13e277e86b0559eca4f21d788f791c4b72dc632c679e6d0df1e0a41"
    sha256 cellar: :any_skip_relocation, ventura:        "57f5ce129792f216e5fccac9555347c1893cd351616a03f40e5528d015cafa87"
    sha256 cellar: :any_skip_relocation, monterey:       "9c6d8457f13e277e86b0559eca4f21d788f791c4b72dc632c679e6d0df1e0a41"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e4807a0ae4f1c4ce36889bfe05dba006388b1eac826b9e7f3edef41ee2e778fd"
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
      assert_predicate testpath/"servers/.pid/defaultServer.pid", :exist?
    ensure
      system bin/"openliberty-microprofile4", "stop"
    end

    refute_predicate testpath/"servers/.pid/defaultServer.pid", :exist?
    assert_match "<feature>microProfile-4.1</feature>", (testpath/"servers/defaultServer/server.xml").read
  end
end
