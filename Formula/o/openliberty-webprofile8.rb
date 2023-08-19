class OpenlibertyWebprofile8 < Formula
  desc "Lightweight open framework for Java (Jakarta EE Web Profile 8)"
  homepage "https://openliberty.io"
  url "https://public.dhe.ibm.com/ibmdl/export/pub/software/openliberty/runtime/release/23.0.0.7/openliberty-webProfile8-23.0.0.7.zip"
  sha256 "77688128decc9acdc5effa3f35e39b71c3aa56c87b395597071c80ba50e30435"
  license "EPL-1.0"

  livecheck do
    url "https://openliberty.io/api/builds/data"
    regex(/openliberty[._-]v?(\d+(?:\.\d+)+)\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "36020106c880d15bffab8292b9567c84c3b186f7d0faf84f2400e9c6081264f3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "36020106c880d15bffab8292b9567c84c3b186f7d0faf84f2400e9c6081264f3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "36020106c880d15bffab8292b9567c84c3b186f7d0faf84f2400e9c6081264f3"
    sha256 cellar: :any_skip_relocation, ventura:        "36020106c880d15bffab8292b9567c84c3b186f7d0faf84f2400e9c6081264f3"
    sha256 cellar: :any_skip_relocation, monterey:       "36020106c880d15bffab8292b9567c84c3b186f7d0faf84f2400e9c6081264f3"
    sha256 cellar: :any_skip_relocation, big_sur:        "36020106c880d15bffab8292b9567c84c3b186f7d0faf84f2400e9c6081264f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2da4c1a40cb85ffe345cac02f5a6bfb9cc8895d00be117012f794528510ffbfa"
  end

  depends_on "openjdk"

  def install
    rm_rf Dir["bin/**/*.bat"]

    prefix.install_metafiles
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
