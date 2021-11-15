class DitaOt < Formula
  desc "DITA Open Toolkit is an implementation of the OASIS DITA specification"
  homepage "https://www.dita-ot.org/"
  url "https://github.com/dita-ot/dita-ot/releases/download/3.6.1/dita-ot-3.6.1.zip"
  sha256 "ebddd6152d44467a794bcfc5d28cf5effd005330677d6a8aafa5de00f250688b"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bb3c63160256f78fbbb2bb3dccfb80a4577f5116a00c00128652e7ce96194b88"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bb3c63160256f78fbbb2bb3dccfb80a4577f5116a00c00128652e7ce96194b88"
    sha256 cellar: :any_skip_relocation, monterey:       "d2962c76fd1ab8527a8ca065d73abe37cf0898b647368826e6d1f39e3e59cd5f"
    sha256 cellar: :any_skip_relocation, big_sur:        "d2962c76fd1ab8527a8ca065d73abe37cf0898b647368826e6d1f39e3e59cd5f"
    sha256 cellar: :any_skip_relocation, catalina:       "d2962c76fd1ab8527a8ca065d73abe37cf0898b647368826e6d1f39e3e59cd5f"
    sha256 cellar: :any_skip_relocation, mojave:         "d2962c76fd1ab8527a8ca065d73abe37cf0898b647368826e6d1f39e3e59cd5f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bb3c63160256f78fbbb2bb3dccfb80a4577f5116a00c00128652e7ce96194b88"
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
