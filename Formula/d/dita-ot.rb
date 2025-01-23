class DitaOt < Formula
  desc "DITA Open Toolkit is an implementation of the OASIS DITA specification"
  homepage "https://www.dita-ot.org/"
  url "https://github.com/dita-ot/dita-ot/releases/download/4.2.4/dita-ot-4.2.4.zip"
  sha256 "d8f66d3d2ddd628398b79b0eccb10acc2a28c54206b958f629cd54c6795eeb88"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1c758b5ed07493d17ec4c1cc9c556e5df0ae141f5a19d671697e4fcb0acaac00"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1c758b5ed07493d17ec4c1cc9c556e5df0ae141f5a19d671697e4fcb0acaac00"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1c758b5ed07493d17ec4c1cc9c556e5df0ae141f5a19d671697e4fcb0acaac00"
    sha256 cellar: :any_skip_relocation, sonoma:        "d7baa9a7a2816335e474e3fb110c55bae58dd8f0c79a670ba248a1bbd83de301"
    sha256 cellar: :any_skip_relocation, ventura:       "d7baa9a7a2816335e474e3fb110c55bae58dd8f0c79a670ba248a1bbd83de301"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a8ff14873b2335b8b358f829ccc9b91fcfda7529367681347df643597e7ec7e8"
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
    assert_predicate testpath/"out/index.html", :exist?
  end
end
