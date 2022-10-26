class DitaOt < Formula
  desc "DITA Open Toolkit is an implementation of the OASIS DITA specification"
  homepage "https://www.dita-ot.org/"
  url "https://github.com/dita-ot/dita-ot/releases/download/3.7.4/dita-ot-3.7.4.zip"
  sha256 "2eb8289a34a2f4c1ebb57381d37a6207b377542f09babc1e0a82e7eb65a3b0ae"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9bacf2aaa47f35139420e17745c75dfe86e25035b064364ac5abadb1e1b37221"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9bacf2aaa47f35139420e17745c75dfe86e25035b064364ac5abadb1e1b37221"
    sha256 cellar: :any_skip_relocation, monterey:       "3d64628950b465b61feaf38052ba6f8f3f81679f140ce84a9c159b77b9a4c485"
    sha256 cellar: :any_skip_relocation, big_sur:        "3d64628950b465b61feaf38052ba6f8f3f81679f140ce84a9c159b77b9a4c485"
    sha256 cellar: :any_skip_relocation, catalina:       "3d64628950b465b61feaf38052ba6f8f3f81679f140ce84a9c159b77b9a4c485"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f4c2117012a63fcd8583f752278bfa2767dcfec87072edbd15a015fc2b18e590"
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
