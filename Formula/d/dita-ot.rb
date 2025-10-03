class DitaOt < Formula
  desc "DITA Open Toolkit is an implementation of the OASIS DITA specification"
  homepage "https://www.dita-ot.org/"
  url "https://github.com/dita-ot/dita-ot/releases/download/4.3.4/dita-ot-4.3.4.zip"
  sha256 "011c65bbe55b917f572e8d8e81a5518504cff0706b436f1c8a6565a1d2d98f08"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "58212d549d69642517b4b1abeaacb9da8d76105fd1a7bea9b6dade03f21ecb94"
  end

  depends_on "openjdk"

  def install
    rm(Dir["bin/*.bat", "config/env.bat", "startcmd.*"])
    libexec.install Dir["*"]
    (bin/"dita").write_env_script libexec/"bin/dita", JAVA_HOME: Formula["openjdk"].opt_prefix

    # Build an `:all` bottle by removing doc file.
    rm libexec/"docsrc/topics/installing-via-homebrew.dita"
  end

  test do
    system bin/"dita", "--input=#{libexec}/docsrc/site.ditamap",
                       "--format=html5",
                       "--output=#{testpath}/out"
    assert_path_exists testpath/"out/index.html"
  end
end
