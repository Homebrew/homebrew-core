class Mx < Formula
  desc "Command-line tool used for the development of Graal projects"
  homepage "https://github.com/graalvm/mx"
  url "https://github.com/graalvm/mx/archive/refs/tags/7.25.14.tar.gz"
  sha256 "5eb750eb90f47d122d75f57cd01072b2a28a6f59846f3130b72a3132e8800499"
  license "GPL-2.0-only"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "dd355fd19ae55cbbba986475d37b033f161f1989c6cb96f2c562a57b764b390c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dd355fd19ae55cbbba986475d37b033f161f1989c6cb96f2c562a57b764b390c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dd355fd19ae55cbbba986475d37b033f161f1989c6cb96f2c562a57b764b390c"
    sha256 cellar: :any_skip_relocation, sonoma:         "dd355fd19ae55cbbba986475d37b033f161f1989c6cb96f2c562a57b764b390c"
    sha256 cellar: :any_skip_relocation, ventura:        "dd355fd19ae55cbbba986475d37b033f161f1989c6cb96f2c562a57b764b390c"
    sha256 cellar: :any_skip_relocation, monterey:       "dd355fd19ae55cbbba986475d37b033f161f1989c6cb96f2c562a57b764b390c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c5ce1798e2fd77acbcf73ab6ca7714828c7bbd20e9602ff03b0fb5744bc614f1"
  end

  depends_on "openjdk" => :test
  depends_on "python@3.12"

  def install
    libexec.install Dir["*"]
    (bin/"mx").write_env_script libexec/"mx", MX_PYTHON: "#{Formula["python@3.12"].opt_libexec}/bin/python"
    bash_completion.install libexec/"bash_completion/mx" => "mx"
  end

  def post_install
    # Run a simple `mx` command to create required empty directories inside libexec
    Dir.mktmpdir do |tmpdir|
      with_env(HOME: tmpdir) do
        system bin/"mx", "--user-home", tmpdir, "version"
      end
    end
  end

  test do
    resource "homebrew-testdata" do
      url "https://github.com/oracle/graal/archive/refs/tags/vm-22.3.2.tar.gz"
      sha256 "77c7801038f0568b3c2ef65924546ae849bd3bf2175e2d248c35ba27fd9d4967"
    end

    ENV["JAVA_HOME"] = Language::Java.java_home
    ENV["MX_ALT_OUTPUT_ROOT"] = testpath

    testpath.install resource("homebrew-testdata")
    cd "vm" do
      output = shell_output("#{bin}/mx suites")
      assert_match "distributions:", output
    end
  end
end
