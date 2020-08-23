class Beast < Formula
  desc "Bayesian Evolutionary Analysis Sampling Trees"
  homepage "https://beast.community/"
  url "https://github.com/beast-dev/beast-mcmc/archive/v1.10.4.tar.gz"
  sha256 "6e28e2df680364867e088acd181877a5d6a1d664f70abc6eccc2ce3a34f3c54a"
  license "LGPL-2.1"
  revision 1
  head "https://github.com/beast-dev/beast-mcmc.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "5f4b312595410d83df9099dc15657241dc4cb758d58a5836565127275a6fb912" => :catalina
    sha256 "d441fd3733557c8de6c227663566e9ac668562a7ecf113504a8c604490752763" => :mojave
    sha256 "2c157d2d74ef17b3fcf8f5cf11d62d1b7ba939f0d7d48872d83706cbeb2b2908" => :high_sierra
  end

  depends_on "ant" => :build
  depends_on "beagle"
  depends_on "openjdk@11"

  def install
    ENV["JAVA_HOME"] = Formula["openjdk@11"].opt_prefix
    system "ant", "linux"
    libexec.install Dir["release/Linux/BEASTv*/*"]
    pkgshare.install_symlink libexec/"examples"
    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files libexec/"bin", JAVA_HOME: ENV["JAVA_HOME"]
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
