class OpenlibertyJakartaee9 < Formula
  desc "Lightweight open framework for Java (Jakarta EE 9)"
  homepage "https://openliberty.io"
  url "https://public.dhe.ibm.com/ibmdl/export/pub/software/openliberty/runtime/release/23.0.0.2/openliberty-jakartaee9-23.0.0.2.zip"
  sha256 "32f267a1dceae26d9349deb252581ff7e33e2b1a6f324b9f430ad23b16efe67e"
  license "EPL-1.0"

  livecheck do
    url "https://openliberty.io/api/builds/data"
    regex(/openliberty[._-]v?(\d+(?:\.\d+)+)\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c8533a967bdb5d4e22fe513e0b65bfe3216fc11686b132fbdc64e1629e88402a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cacea6b1cccc4c369eca0693884d8223b7d0db7baf4ce2d9dfc28d6f983cface"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3efbf936f28497375bf7623baebeb85a20dfa4605363f7d6e2cc162ddb1e0bde"
    sha256 cellar: :any_skip_relocation, ventura:        "9bc8134802b9dff4162ce77dc8b2bd20df22e99b11cbcfe7afd6cf6326540e60"
    sha256 cellar: :any_skip_relocation, monterey:       "899f85319aac4806bff3346650b31576a7c3940ee6571a98c334c9a31a02b1e0"
    sha256 cellar: :any_skip_relocation, big_sur:        "16cc8ef275f6d3d6d1d99d09e6658dde6bdfbeade9a9f679285371b23b3d94d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "547c761b63e58bdc97c27a46729cb71ad69ce734c0840fd03bfdbf1b426e9bff"
  end

  depends_on "openjdk"

  def install
    rm_rf Dir["bin/**/*.bat"]

    prefix.install_metafiles
    libexec.install Dir["*"]
    (bin/"openliberty-jakartaee9").write_env_script "#{libexec}/bin/server",
                                                    Language::Java.overridable_java_home_env
  end

  def caveats
    <<~EOS
      The home of Open Liberty Jakarta EE 9 is:
        #{opt_libexec}
    EOS
  end

  test do
    ENV["WLP_USER_DIR"] = testpath

    begin
      system bin/"openliberty-jakartaee9", "start"
      assert_predicate testpath/"servers/.pid/defaultServer.pid", :exist?
    ensure
      system bin/"openliberty-jakartaee9", "stop"
    end

    refute_predicate testpath/"servers/.pid/defaultServer.pid", :exist?
    assert_match "<feature>jakartaee-9.1</feature>", (testpath/"servers/defaultServer/server.xml").read
  end
end
