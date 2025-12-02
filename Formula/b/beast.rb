class Beast < Formula
  desc "Bayesian Evolutionary Analysis Sampling Trees"
  homepage "https://beast.community/"
  url "https://github.com/beast-dev/beast-mcmc/archive/refs/tags/v10.5.0.tar.gz"
  sha256 "6287ebbe85e65e44f421b7e9ec3fd17d9a736ff909dfa3b4ab6b1b1fd361b52b"
  license "LGPL-2.1-or-later"
  head "https://github.com/beast-dev/beast-mcmc.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f6bea503ebf5a08dec482d702efc5deb9a582e508b02c0801676e5b12d81cc38"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3b8a6e27f0f6d7d2ea5975527fcaeb26e12e85084ada04504faf8648e49c68aa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "14251bfb6655c4a41182c877f335e7a52d94b0cf19944b6a84503114ffe9d225"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0d3c7f2ada5fe41129297cb1d3982c820795caf49df73ef195809a105b6fc7b1"
    sha256 cellar: :any_skip_relocation, sonoma:        "26662c5e73e42985a75df7fb1fa10f74eff789aa3271daf497323c8c66725dee"
    sha256 cellar: :any_skip_relocation, ventura:       "293196654c48f797b253a1d07ce9bab5836d5682fbe1772f26a6dc8f64875977"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "68647073986327f94f8ee9ec7e8d4b0e34cb8555378591e99e0ab19f480d9e83"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "34a93fd16e042a40f5d18973a31931ea504884cacb750acaabb1772a891435d3"
  end

  depends_on "ant" => :build
  depends_on "beagle"
  depends_on "openjdk"

  def install
    ENV["JAVA_HOME"] = Language::Java.java_home
    system "ant", "linux"
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

    # OpenCL is not supported on virtualized arm64 macOS and causes all beast commands to fail
    if OS.mac? && Hardware::CPU.arm? && Hardware::CPU.virtualized?
      output = shell_output("#{bin}/beast testUCRelaxedClockLogNormal.xml 2>&1", 255)
      assert_match "OpenCL error: CL_INVALID_VALUE", output
      return
    end

    system bin/"beast", "testUCRelaxedClockLogNormal.xml"

    %w[ops log trees].each do |ext|
      output = "testUCRelaxedClockLogNormal." + ext
      assert_path_exists testpath/output, "Failed to create #{output}"
    end
  end
end
