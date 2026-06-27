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
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b107a5edd728816ef7165865357969675e088181f19e83c6a9a2b5ce2e116312"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4d872467d67eaf343cf3f19f857dcadf1801081fde1b0def66a5c5e6c1de0e12"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e172d94ce8e6d5e1f4e71d96e3badd35a781f7de4a35ec9f3547ebecfb1ea821"
    sha256 cellar: :any_skip_relocation, sonoma:        "271c25efad35403b8c49c6caa31c6a21a2f486624ea0f5203174691a6dfaa613"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "63b7d3b4fe5dc9a4468424a86832701ea99c690481040dc444d832528b6680f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7ac4f0df6c90dd7dddd0b19757f1c1ad14462b253743d09cafb94f6b20367b65"
  end

  depends_on "ant" => :build
  depends_on "beagle"
  depends_on "openjdk@25"

  def install
    ENV["JAVA_HOME"] = Language::Java.java_home("25")
    system "ant", "linux"
    libexec.install Dir["release/Linux/BEAST_X_v*/*"]
    pkgshare.install_symlink libexec/"examples"
    bin.install Dir[libexec/"bin/*"]

    env = Language::Java.overridable_java_home_env("25")
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
