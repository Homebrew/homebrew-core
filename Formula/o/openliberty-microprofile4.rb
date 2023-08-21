class OpenlibertyMicroprofile4 < Formula
  desc "Lightweight open framework for Java (Micro Profile 4)"
  homepage "https://openliberty.io"
  url "https://public.dhe.ibm.com/ibmdl/export/pub/software/openliberty/runtime/release/23.0.0.7/openliberty-microProfile4-23.0.0.7.zip"
  sha256 "6322091cd7520161d8d2850a46020a5a6a7a181e5d65fec6acfd72d7c7b60d0a"
  license "EPL-1.0"

  livecheck do
    url "https://openliberty.io/api/builds/data"
    regex(/openliberty[._-]v?(\d+(?:\.\d+)+)\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "17e81fa4fc801ba6388707b825244858d607edfb30cdf3574b5aa25c1b7d6dbc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "17e81fa4fc801ba6388707b825244858d607edfb30cdf3574b5aa25c1b7d6dbc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "17e81fa4fc801ba6388707b825244858d607edfb30cdf3574b5aa25c1b7d6dbc"
    sha256 cellar: :any_skip_relocation, ventura:        "17e81fa4fc801ba6388707b825244858d607edfb30cdf3574b5aa25c1b7d6dbc"
    sha256 cellar: :any_skip_relocation, monterey:       "17e81fa4fc801ba6388707b825244858d607edfb30cdf3574b5aa25c1b7d6dbc"
    sha256 cellar: :any_skip_relocation, big_sur:        "17e81fa4fc801ba6388707b825244858d607edfb30cdf3574b5aa25c1b7d6dbc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e475a724d008e3d3dc56c2521309be3700813dbb17fef56d450f2fa28da61077"
  end

  depends_on "openjdk"

  def install
    rm_rf Dir["bin/**/*.bat"]

    prefix.install_metafiles
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
