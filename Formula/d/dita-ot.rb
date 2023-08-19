class DitaOt < Formula
  desc "DITA Open Toolkit is an implementation of the OASIS DITA specification"
  homepage "https://www.dita-ot.org/"
  url "https://github.com/dita-ot/dita-ot/releases/download/4.1.1/dita-ot-4.1.1.zip"
  sha256 "a86ae9499ddba7f9703e1ae3eeaa6ea9f83b8a128ec6c4b01adaf803cf9d1cfb"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2aeefbf349a91e9c1507505e55571ce25643b1f17f585461534aaee33d4ec867"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2aeefbf349a91e9c1507505e55571ce25643b1f17f585461534aaee33d4ec867"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2aeefbf349a91e9c1507505e55571ce25643b1f17f585461534aaee33d4ec867"
    sha256 cellar: :any_skip_relocation, ventura:        "a30970174eb19921756e13b48ca1bca143c78633ad31f93b51757b502b23d42e"
    sha256 cellar: :any_skip_relocation, monterey:       "a30970174eb19921756e13b48ca1bca143c78633ad31f93b51757b502b23d42e"
    sha256 cellar: :any_skip_relocation, big_sur:        "a30970174eb19921756e13b48ca1bca143c78633ad31f93b51757b502b23d42e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "03fe56d9b44a8dc175884dfc0f525cb0edc6e7d98a0176c0bc045dbe5a7dc0a5"
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
