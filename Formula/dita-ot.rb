class DitaOt < Formula
  desc "DITA Open Toolkit is an implementation of the OASIS DITA specification"
  homepage "https://www.dita-ot.org/"
  url "https://github.com/dita-ot/dita-ot/releases/download/4.0.2/dita-ot-4.0.2.zip"
  sha256 "a15cbc11f351304b20fa84de4823fef12c2e5eaa14b207c8d98814d849951852"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7cb4c3b63bb88096938a310dd937d855397bf6e08740fca39b1fd71a71132da1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7cb4c3b63bb88096938a310dd937d855397bf6e08740fca39b1fd71a71132da1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7cb4c3b63bb88096938a310dd937d855397bf6e08740fca39b1fd71a71132da1"
    sha256 cellar: :any_skip_relocation, ventura:        "3f1b709adf44d5237507132cb99eb5d8215e5d4dbea604d8a282e9a92c85dde7"
    sha256 cellar: :any_skip_relocation, monterey:       "3f1b709adf44d5237507132cb99eb5d8215e5d4dbea604d8a282e9a92c85dde7"
    sha256 cellar: :any_skip_relocation, big_sur:        "3f1b709adf44d5237507132cb99eb5d8215e5d4dbea604d8a282e9a92c85dde7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c277d6a7ac2a85f72fb6d8c58c0ff5075dfcec957d9361cc78a188fcd9c22745"
  end

  depends_on "openjdk"

  def install
    rm_f Dir["bin/*.bat", "config/env.bat", "startcmd.*"]
    libexec.install Dir["*"]
    (bin/"dita").write_env_script libexec/"bin/dita", JAVA_HOME: Formula["openjdk"].opt_prefix
  end

  test do
    system bin/"dita", "--input=#{libexec}/docsrc/site.ditamap",
           "--format=html5", "--output=#{testpath}/out"
    assert_predicate testpath/"out/index.html", :exist?
  end
end
