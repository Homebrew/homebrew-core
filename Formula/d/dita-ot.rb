class DitaOt < Formula
  desc "DITA Open Toolkit is an implementation of the OASIS DITA specification"
  homepage "https://www.dita-ot.org/"
  url "https://github.com/dita-ot/dita-ot/releases/download/4.3/dita-ot-4.3.zip"
  sha256 "b5d70980a39dca1d2a758157eb4a8aa2db7c4c262dd3ba6a9b7ca0aef9fc7ea8"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fb48d13f245d604f3da8f75f93dbdfae4eab73988512aab0918e85f37b961d79"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fb48d13f245d604f3da8f75f93dbdfae4eab73988512aab0918e85f37b961d79"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fb48d13f245d604f3da8f75f93dbdfae4eab73988512aab0918e85f37b961d79"
    sha256 cellar: :any_skip_relocation, sonoma:        "a42917030c3e210e05aac9ef4274668985f0361d95157bf7be3f823bbb6d1908"
    sha256 cellar: :any_skip_relocation, ventura:       "a42917030c3e210e05aac9ef4274668985f0361d95157bf7be3f823bbb6d1908"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "76107adc6d0aa00fbb887a4c3de9862498e4cb84a1fb7f70686d5b9ff3c07ee0"
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
