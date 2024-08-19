class OpenlibertyWebprofile8 < Formula
  desc "Lightweight open framework for Java (Jakarta EE Web Profile 8)"
  homepage "https://openliberty.io"
  url "https://public.dhe.ibm.com/ibmdl/export/pub/software/openliberty/runtime/release/24.0.0.7/openliberty-webProfile8-24.0.0.7.zip"
  sha256 "a5d188a8a48ea3bbe8dc3e9357e889f2c46f4d7eece867ecb5c983234890819a"
  license "EPL-1.0"

  livecheck do
    url "https://openliberty.io/api/builds/data"
    regex(/openliberty[._-]v?(\d+(?:\.\d+)+)\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ea3c4a5101d11f7064d1a06313c2732f61bb115d806737d43da4c560bf6c7a85"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ea3c4a5101d11f7064d1a06313c2732f61bb115d806737d43da4c560bf6c7a85"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ea3c4a5101d11f7064d1a06313c2732f61bb115d806737d43da4c560bf6c7a85"
    sha256 cellar: :any_skip_relocation, sonoma:         "22686b9b2d87bc5e7f1ebda8d66110489b3d474ca55ef710b92ca92497a3b343"
    sha256 cellar: :any_skip_relocation, ventura:        "d24738571641aaaa14a1decde854e172eee5b8364c8c28d27f9ad3265215364a"
    sha256 cellar: :any_skip_relocation, monterey:       "ea3c4a5101d11f7064d1a06313c2732f61bb115d806737d43da4c560bf6c7a85"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bdff773c32c9f46df52b624c6d33e1205a8275da735355c52d0a61944a61de35"
  end

  depends_on "openjdk"

  def install
    rm_r(Dir["bin/**/*.bat"])

    libexec.install Dir["*"]
    (bin/"openliberty-webprofile8").write_env_script "#{libexec}/bin/server",
                                                     Language::Java.overridable_java_home_env
  end

  def caveats
    <<~EOS
      The home of Open Liberty Jakarta EE Web Profile 8 is:
        #{opt_libexec}
    EOS
  end

  test do
    ENV["WLP_USER_DIR"] = testpath

    begin
      system bin/"openliberty-webprofile8", "start"
      assert_predicate testpath/"servers/.pid/defaultServer.pid", :exist?
    ensure
      system bin/"openliberty-webprofile8", "stop"
    end

    refute_predicate testpath/"servers/.pid/defaultServer.pid", :exist?
    assert_match "<feature>webProfile-8.0</feature>", (testpath/"servers/defaultServer/server.xml").read
  end
end
