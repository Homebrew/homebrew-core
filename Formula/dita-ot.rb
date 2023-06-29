class DitaOt < Formula
  desc "DITA Open Toolkit is an implementation of the OASIS DITA specification"
  homepage "https://www.dita-ot.org/"
  url "https://github.com/dita-ot/dita-ot/releases/download/4.1/dita-ot-4.1.zip"
  sha256 "7bd0c7471c5fda530f88f32c54f3f8ea9083ba0b64526f5c17c1a2202b398c46"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c96d0aac084db3da8b6136568bdb8f5f0b14b2a9f1cece1546e5f81d220adfe2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c96d0aac084db3da8b6136568bdb8f5f0b14b2a9f1cece1546e5f81d220adfe2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c96d0aac084db3da8b6136568bdb8f5f0b14b2a9f1cece1546e5f81d220adfe2"
    sha256 cellar: :any_skip_relocation, ventura:        "15c7197f58c88352e089134fff76cf53d30dd4036c983cbeab7b4637845ab81a"
    sha256 cellar: :any_skip_relocation, monterey:       "15c7197f58c88352e089134fff76cf53d30dd4036c983cbeab7b4637845ab81a"
    sha256 cellar: :any_skip_relocation, big_sur:        "15c7197f58c88352e089134fff76cf53d30dd4036c983cbeab7b4637845ab81a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "683cb9bb6ef9ea4db91bdc18a9c4cd9ee37292e44862f0aa419e50e0831b0cee"
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
