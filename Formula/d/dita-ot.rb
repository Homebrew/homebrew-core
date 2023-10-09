class DitaOt < Formula
  desc "DITA Open Toolkit is an implementation of the OASIS DITA specification"
  homepage "https://www.dita-ot.org/"
  url "https://github.com/dita-ot/dita-ot/releases/download/4.1.2/dita-ot-4.1.2.zip"
  sha256 "22c47043210965349e842c46ef15e2dac2a5f784d08d9d026d5a7b1674a69223"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4c7ef66a99044278fa22b527ffa21537d037cb718ffade4e338f64119d620d3b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4c7ef66a99044278fa22b527ffa21537d037cb718ffade4e338f64119d620d3b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4c7ef66a99044278fa22b527ffa21537d037cb718ffade4e338f64119d620d3b"
    sha256 cellar: :any_skip_relocation, sonoma:         "135aed4383b506123cdc8c4c48305defb1eb1b11e4f062a68b5fc20c4ff27388"
    sha256 cellar: :any_skip_relocation, ventura:        "135aed4383b506123cdc8c4c48305defb1eb1b11e4f062a68b5fc20c4ff27388"
    sha256 cellar: :any_skip_relocation, monterey:       "135aed4383b506123cdc8c4c48305defb1eb1b11e4f062a68b5fc20c4ff27388"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1a7c08c735ec3ea8bd1c4b52cadf36ae423b579df0ed4354dc7904ed7512309b"
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
