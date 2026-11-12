class Beast < Formula
  desc "Bayesian Evolutionary Analysis Sampling Trees"
  homepage "https://beast.community/"
  url "https://github.com/beast-dev/beast-mcmc/archive/refs/tags/v10.6.0.tar.gz"
  sha256 "1b012f15d90438a532950e5156ba495f763157478edd46853b763ac53a0831af"
  license "LGPL-2.1-or-later"
  head "https://github.com/beast-dev/beast-mcmc.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b01984684bec8c75f9f340b3316742ce2749c1134c5bfd44e32fae12888d1b48"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "852287f0b7c92e35e11319fab8d0d52d298bb27fcb4a6c562e5b6c85611a014b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "63cfce71d6837a9a31d27471b8b8c9be64be2aebd355f9ebefebe989aa41d445"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "73371051eaf4191dd96937212f4e4ab907ee5c9b44c1b635fff8e7d39c06eeba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "45ef71fa01bca5bceeae0208a58fbd97163f437efb7e3c1206e9666d3d11a272"
  end

  depends_on "ant" => :build
  depends_on "beagle"
  depends_on "openjdk"

  deny_network_access!

  def install
    ENV["JAVA_HOME"] = Language::Java.java_home
    system "ant"
    system "ant", "package-linux", "-f", "build_release.xml"
    libexec.install Dir["release/Linux/BEAST_X_v*/*"]
    pkgshare.install_symlink libexec/"examples"
    bin.install Dir[libexec/"bin/*"]

    env = Language::Java.overridable_java_home_env
    env["PATH"] = "${JAVA_HOME}/bin:${PATH}" if OS.linux?
    bin.env_script_all_files libexec/"bin", env
    inreplace libexec/"bin/beast", "/usr/local", HOMEBREW_PREFIX
  end

  test do
    cp pkgshare/"examples/TestXML/ClockModels/testUCRelaxedClockLogNormal.xml", testpath

    # Run fewer generations to speed up tests
    inreplace "testUCRelaxedClockLogNormal.xml", 'chainLength="10000000"',
                                                 'chainLength="100000"'

    system bin/"beast", "testUCRelaxedClockLogNormal.xml"

    samples = (testpath/"testUCRelaxedClockLogNormal.log").read.lines.reject { |line| line.start_with?("#") }
    columns = samples.shift.split
    result = columns.zip(samples.last.split).to_h
    assert_equal "100000", result.fetch("state")
    %w[posterior prior likelihood].each do |statistic|
      assert Float(result.fetch(statistic)).finite?, "Non-finite #{statistic}"
    end
    assert_in_delta Float(result.fetch("prior")) + Float(result.fetch("likelihood")),
                    Float(result.fetch("posterior")), 1e-5
  end
end
