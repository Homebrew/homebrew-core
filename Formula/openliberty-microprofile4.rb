class OpenlibertyMicroprofile4 < Formula
  desc "Lightweight open framework for Java (Micro Profile 4)"
  homepage "https://openliberty.io"
  url "https://public.dhe.ibm.com/ibmdl/export/pub/software/openliberty/runtime/release/23.0.0.2/openliberty-microProfile4-23.0.0.2.zip"
  sha256 "e27c03c78906c1ecf6ef090fbe24e6611fc808ee6a064fdddfb509336ab46a9a"
  license "EPL-1.0"

  livecheck do
    url "https://openliberty.io/api/builds/data"
    regex(/openliberty[._-]v?(\d+(?:\.\d+)+)\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "22ea91274a4cbad6720a6418ec4bd84c994a480a7931efd50517a383869f7034"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0cd9bc6a4ba925400c7e1a64d08fad358f61457e6e8cb2fb8a71609f63aae4c5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "57a9a04e28fac8c649d6b6cd88413a81123b4b6b55c9186a94ce20d2919ea450"
    sha256 cellar: :any_skip_relocation, ventura:        "a09adef57a9495443aa543892b50ba13b0e6c9a23d2f19ac699472f94819a51a"
    sha256 cellar: :any_skip_relocation, monterey:       "a550b20d68ffcc92db5b0bd982b1efa629eeffa6ec518c38eadff966e4953c60"
    sha256 cellar: :any_skip_relocation, big_sur:        "0d657ba32f6e38e1499edaa4ac9635beba76476e0fb745b3e5de781ffd285d5f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "55a23de7e77cfa899131df1c11ae027da883a34fd6c29ae6330ed0ed27103a6f"
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
