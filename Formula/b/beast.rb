class Beast < Formula
  desc "Bayesian Evolutionary Analysis Sampling Trees"
  homepage "https://beast.community/"
  url "https://github.com/beast-dev/beast-mcmc/archive/refs/tags/v1.10.4.tar.gz"
  sha256 "6e28e2df680364867e088acd181877a5d6a1d664f70abc6eccc2ce3a34f3c54a"
  license "LGPL-2.1-or-later"
  revision 1
  head "https://github.com/beast-dev/beast-mcmc.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5f161a2d0544992fe9471b5b6b03dde90fdc0f02c7a92d1a56ba8e692026b9e8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8530ad41042e8638c8aaa89dcee67c4f9a1cce11e192722d8d10c055fb85d10e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3475a2a399c4c91c538e8d5f802070826df46a9f1f7efcdc92ef643558013784"
    sha256 cellar: :any_skip_relocation, sonoma:        "b7f6d9ba542e77f28f82574b63097ef4a5000661ce725f9a7aa7e77e9d3f4e52"
    sha256 cellar: :any_skip_relocation, ventura:       "5290a805fd0c62089889729bc188fd7ddb6ea51e077c1a33045e6b2ff630585e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4d830864a6ea1dd1d984b70cb438ce3b17dabb3120640decf0e8136b37483517"
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

    # OpenCL is not supported on virtualized arm64 macOS and causes all beast commands to fail
    if OS.mac? && Hardware::CPU.arm? && Hardware::CPU.virtualized?
      output = shell_output("#{bin}/beast testUCRelaxedClockLogNormal.xml 2>&1", 255)
      assert_match "OpenCL error: CL_INVALID_VALUE", output
      return
    end

    system bin/"beast", "testUCRelaxedClockLogNormal.xml"

    %w[ops log trees].each do |ext|
      output = "testUCRelaxedClockLogNormal." + ext
      assert_predicate testpath/output, :exist?, "Failed to create #{output}"
    end
  end
end
