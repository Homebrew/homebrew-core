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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "03ef21e8e09a14e2dbb1ec675f3c1f8a94a694a53d17edb85f1017e61723f155"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "03ef21e8e09a14e2dbb1ec675f3c1f8a94a694a53d17edb85f1017e61723f155"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "03ef21e8e09a14e2dbb1ec675f3c1f8a94a694a53d17edb85f1017e61723f155"
    sha256 cellar: :any_skip_relocation, ventura:        "0e8aca56693aaea7a85167844c4b8ec7f50bfc063caee1222d5d5591aebeafc2"
    sha256 cellar: :any_skip_relocation, monterey:       "0e8aca56693aaea7a85167844c4b8ec7f50bfc063caee1222d5d5591aebeafc2"
    sha256 cellar: :any_skip_relocation, big_sur:        "0e8aca56693aaea7a85167844c4b8ec7f50bfc063caee1222d5d5591aebeafc2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "13d78ca4265a072344dc261aac5383fe1d72f04c9948896c7d1ad1ed9ea68f0a"
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
