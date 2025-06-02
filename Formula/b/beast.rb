class Beast < Formula
  desc "Bayesian Evolutionary Analysis Sampling Trees"
  homepage "https://beast.community/"
  license "LGPL-2.1-or-later"
  revision 1
  head "https://github.com/beast-dev/beast-mcmc.git", branch: "master"

  stable do
    url "https://github.com/beast-dev/beast-mcmc/archive/refs/tags/v1.10.4.tar.gz"
    sha256 "6e28e2df680364867e088acd181877a5d6a1d664f70abc6eccc2ce3a34f3c54a"

    # Backport support for building on newer OpenJDK
    patch do
      url "https://github.com/beast-dev/beast-mcmc/commit/3b91c1d391daf350c92f84c5900b58ff72a889af.patch?full_index=1"
      sha256 "64511255b4cd3339ad9be5a6b1cb98283cb279cab5a60913b9a1619433b702f7"
    end
  end

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1ec7cd636c5eb6427da2a75bb75976143fbae45c8d91e572d6dadb98913ac181"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "28cab0636b496492f69e99401ef9ab308380020d757534983109f09d6a2237ae"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "dc1635820e1fc7927203e32b9889e9a40046347d41da139a5242732b69113003"
    sha256 cellar: :any_skip_relocation, sonoma:        "bb2c0e36ea56bc4da5acd32fc8b94d3790b4941ae0a96c329edc09bdcda964f5"
    sha256 cellar: :any_skip_relocation, ventura:       "addf828a1d4ee838921507d1c937a9ca17ea2b4666193461237fc218a1b1bddc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f5cb0610f7b28b36cb020c8d6075523e4e73aee036b928823361059e4e86ce29"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8974bcba1ac12db8bad1ccdd47976f468ea9f7739eb0d43fe120bb93e1cef388"
  end

  depends_on "ant" => :build
  depends_on "beagle"
  depends_on "openjdk"

  def install
    ENV["JAVA_HOME"] = Language::Java.java_home
    system "ant", "linux"
    libexec.install Dir["release/Linux/BEASTv*/*"]
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
