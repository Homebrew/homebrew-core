class Beast < Formula
  desc "Bayesian Evolutionary Analysis Sampling Trees"
  homepage "https://beast.community/"
  url "https://github.com/beast-dev/beast-mcmc/archive/v1.10.4.tar.gz"
  sha256 "6e28e2df680364867e088acd181877a5d6a1d664f70abc6eccc2ce3a34f3c54a"
  license "LGPL-2.1-or-later"
  revision 1
  head "https://github.com/beast-dev/beast-mcmc.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0cd65d3171bde73b59cc5d5489eb2ab07c284225e3b30c2c160de61ec29df98a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5f9d2180a3cecd5c8b361318f792a34496e958081b1d9fc731dbd933673498a5"
    sha256 cellar: :any_skip_relocation, ventura:        "60b399b07572609d7661317b1e54c99cbb704d229ea78df4afdcf4adc74db659"
    sha256 cellar: :any_skip_relocation, monterey:       "ec4938ae3249e4f6d1a312c14550ec4da837a7b572bbd0d4b7238fb5ca7f0728"
    sha256 cellar: :any_skip_relocation, big_sur:        "90bc7bcf414bfc4d9a68e7dbade089260bb12483939a78a136cdb9b2ea1a3bcb"
    sha256 cellar: :any_skip_relocation, catalina:       "5f4b312595410d83df9099dc15657241dc4cb758d58a5836565127275a6fb912"
    sha256 cellar: :any_skip_relocation, mojave:         "d441fd3733557c8de6c227663566e9ac668562a7ecf113504a8c604490752763"
    sha256 cellar: :any_skip_relocation, high_sierra:    "2c157d2d74ef17b3fcf8f5cf11d62d1b7ba939f0d7d48872d83706cbeb2b2908"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cce35bb9ee56a4a093d8893c401609b868eea6782d269d716af31a620d0f82ab"
  end

  depends_on "ant" => :build
  depends_on "beagle"
  depends_on "openjdk@11"

  def install
    ENV["JAVA_HOME"] = Language::Java.java_home("11")
    system "ant", "linux"
    libexec.install Dir["release/Linux/BEASTv*/*"]
    pkgshare.install_symlink libexec/"examples"
    bin.install Dir[libexec/"bin/*"]

    env = Language::Java.overridable_java_home_env("11")
    env["PATH"] = "$JAVA_HOME/bin:$PATH" if OS.linux?
    bin.env_script_all_files libexec/"bin", env
    inreplace libexec/"bin/beast", "/usr/local", HOMEBREW_PREFIX
  end

  test do
    cp pkgshare/"examples/TestXML/ClockModels/testUCRelaxedClockLogNormal.xml", testpath

    # Run fewer generations to speed up tests
    inreplace "testUCRelaxedClockLogNormal.xml", 'chainLength="10000000"',
                                                 'chainLength="100000"'

    system "#{bin}/beast", "testUCRelaxedClockLogNormal.xml"

    %w[ops log trees].each do |ext|
      output = "testUCRelaxedClockLogNormal." + ext
      assert_predicate testpath/output, :exist?, "Failed to create #{output}"
    end
  end
end
