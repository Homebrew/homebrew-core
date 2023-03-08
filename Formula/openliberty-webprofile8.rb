class OpenlibertyWebprofile8 < Formula
  desc "Lightweight open framework for Java (Jakarta EE Web Profile 8)"
  homepage "https://openliberty.io"
  url "https://public.dhe.ibm.com/ibmdl/export/pub/software/openliberty/runtime/release/23.0.0.2/openliberty-webProfile8-23.0.0.2.zip"
  sha256 "59c6766ae1b4ac68c45fe5aaeed014aa19869e8509d037361424c2c681bbd103"
  license "EPL-1.0"

  livecheck do
    url "https://openliberty.io/api/builds/data"
    regex(/openliberty[._-]v?(\d+(?:\.\d+)+)\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "603180ec65e8b7e449f3a0c9ff4744a16be0e30e0ddd9848d75a47499209564a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "763251a89664c7da3ed1e910bd3ea14721fc76d93653db002e57ddc9713adafe"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6d9a119d9a33c26871994fb2b643ad018eb2bfe93265dea4d6176cc067054659"
    sha256 cellar: :any_skip_relocation, ventura:        "7996f9ecf020afc565fe94c06a554bd6c0b8d75c960311b682edc2acca417228"
    sha256 cellar: :any_skip_relocation, monterey:       "6fb3b73acb6dad5797e6b4138b0fd788deb732cbf330f47ee8ed6dfb0d029dec"
    sha256 cellar: :any_skip_relocation, big_sur:        "757980c486accf98a4e437fe2dec8e2ac177f47794d5dbd507eb984d4206852b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ecfa1f21ac7d466b2f3a4b53157d4a985770bece34f601d00b6eadd4bd12a9de"
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
