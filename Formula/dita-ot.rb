class DitaOt < Formula
  desc "DITA Open Toolkit is an implementation of the OASIS DITA specification"
  homepage "https://www.dita-ot.org/"
  url "https://github.com/dita-ot/dita-ot/releases/download/3.7.1/dita-ot-3.7.1.zip"
  sha256 "9a9790de79da566c636b805e5f42e94a8d3c0c187919e5159d1b8a64998b5bbd"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b09ccd7cb0ff165ea05a36e781043b166f4a30388a1fdcd34bd3f105489db7ad"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b09ccd7cb0ff165ea05a36e781043b166f4a30388a1fdcd34bd3f105489db7ad"
    sha256 cellar: :any_skip_relocation, monterey:       "7dcffe2eadd0dbf60e6672a217e699bdee1f26b8a184ad960d8a6f32dbaa2e45"
    sha256 cellar: :any_skip_relocation, big_sur:        "7dcffe2eadd0dbf60e6672a217e699bdee1f26b8a184ad960d8a6f32dbaa2e45"
    sha256 cellar: :any_skip_relocation, catalina:       "7dcffe2eadd0dbf60e6672a217e699bdee1f26b8a184ad960d8a6f32dbaa2e45"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ec590a6d1fca973322efbb02b615e7428a7bc10345cf9907f1188459253d42fd"
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
