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
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b93ad7a4a3bbf61eddf37a461b6822b054b78f4f2abe839e20060a1df15e1661"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "4c13894f640c1c2308eb2c468433b6158f5be1e4ffc074c2e053523590166866"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "39171dbf213c7091c78db76063b50c0457ea42a3ee6c5c21a227815504fceeb3"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "86a46f94d5a378aa2a3a657875c802b2e2be29b9e8c0cea634627eb5a00c16a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "3fbe512596b1d7445bbf50d2f811a5e480d4ac645a86561f1aedd43459cc4d0c"
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
