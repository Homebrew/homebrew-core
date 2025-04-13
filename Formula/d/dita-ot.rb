class DitaOt < Formula
  desc "DITA Open Toolkit is an implementation of the OASIS DITA specification"
  homepage "https://www.dita-ot.org/"
  url "https://github.com/dita-ot/dita-ot/releases/download/4.3.1/dita-ot-4.3.1.zip"
  sha256 "e0c4dbab82de03076d4b7fa7e22bd0ae6ed29a5d63e972fbeb7cb9571cb18e2a"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "68f93968fe8b2a9750f00cf366ebd2a6857035f1fa05d1fe57ca947568783eaf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "68f93968fe8b2a9750f00cf366ebd2a6857035f1fa05d1fe57ca947568783eaf"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "68f93968fe8b2a9750f00cf366ebd2a6857035f1fa05d1fe57ca947568783eaf"
    sha256 cellar: :any_skip_relocation, sonoma:        "1ad7a7dfa44099570465acd1059e89c9ceadb2b6f2cae24fb1aaf74ade65fe8c"
    sha256 cellar: :any_skip_relocation, ventura:       "1ad7a7dfa44099570465acd1059e89c9ceadb2b6f2cae24fb1aaf74ade65fe8c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aed6e7b84c823f4e9c15934449e88ebe0210a7de34ef968bc2785c74634933a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aed6e7b84c823f4e9c15934449e88ebe0210a7de34ef968bc2785c74634933a8"
  end

  depends_on "openjdk"

  def install
    rm(Dir["bin/*.bat", "config/env.bat", "startcmd.*"])
    libexec.install Dir["*"]
    (bin/"dita").write_env_script libexec/"bin/dita", JAVA_HOME: Formula["openjdk"].opt_prefix
  end

  test do
    system bin/"dita", "--input=#{libexec}/docsrc/site.ditamap",
           "--format=html5", "--output=#{testpath}/out"
    assert_path_exists testpath/"out/index.html"
  end
end
