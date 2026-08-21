class DitaOt < Formula
  desc "DITA Open Toolkit is an implementation of the OASIS DITA specification"
  homepage "https://www.dita-ot.org/"
  url "https://github.com/dita-ot/dita-ot/releases/download/4.4.1/dita-ot-4.4.1.zip"
  sha256 "154414c1debb548e923bf77e9a09019e249a8887680ff4bfbd8e137de9e8e250"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c8069bab2aa8041f0ddb36c4a1ecc6f57781c706894cfdaadc3cef0c4c44cfa0"
  end

  depends_on "openjdk"

  def install
    rm(Dir["bin/*.bat", "config/env.bat", "startcmd.*"])
    libexec.install Dir["*"]
    (bin/"dita").write_env_script libexec/"bin/dita", JAVA_HOME: formula_opt_prefix("openjdk")

    # Build an `:all` bottle by removing doc file.
    rm libexec/"docsrc/topics/installing-via-homebrew.dita"
  end

  test do
    system bin/"dita", "--input=#{libexec}/docsrc/site.ditamap",
                       "--format=html5",
                       "--output=#{testpath}/out"
    assert_path_exists testpath/"out/index.html"
  end
end
