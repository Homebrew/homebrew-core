class DitaOt < Formula
  desc "DITA Open Toolkit is an implementation of the OASIS DITA specification"
  homepage "https://www.dita-ot.org/"
  url "https://github.com/dita-ot/dita-ot/releases/download/4.2.3/dita-ot-4.2.3.zip"
  sha256 "0ccf4ec1d26e2de721b7dbd37150c8a06d6ce4cf7c5295c5bd230f4d5dfa7256"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "fe5acc56df080446f49d303825327daad4e273c9505c3775de21899b213d1443"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1dc3d5be57fe24e3b464ff897421958cc3a963d7511f5e56b01c8581cffabf01"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1dc3d5be57fe24e3b464ff897421958cc3a963d7511f5e56b01c8581cffabf01"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1dc3d5be57fe24e3b464ff897421958cc3a963d7511f5e56b01c8581cffabf01"
    sha256 cellar: :any_skip_relocation, sonoma:         "3c52cf6b9307b2c88311a7e9564016e33df3d3f7552697bce3ceb4455e19c78e"
    sha256 cellar: :any_skip_relocation, ventura:        "3c52cf6b9307b2c88311a7e9564016e33df3d3f7552697bce3ceb4455e19c78e"
    sha256 cellar: :any_skip_relocation, monterey:       "3c52cf6b9307b2c88311a7e9564016e33df3d3f7552697bce3ceb4455e19c78e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "96fd328dc0ce29f64f81d3cf6f95e1df32ba7745ed9aeb1909964595e103ce3e"
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
