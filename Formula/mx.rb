class Mx < Formula
  desc "Command-line tool used for the development of Graal projects"
  homepage "https://github.com/graalvm/mx"
  url "https://github.com/graalvm/mx/archive/refs/tags/6.15.1.tar.gz"
  sha256 "7187967123ddc94ab3c4832a630b28d3a40bc9813d413e764a8115dbd705f2f0"
  license "GPL-2.0-only"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "eae980ead238f37090b2a877b025fb60fd1b88ebd813cfd0ea051bdefd2a2926"
  end

  depends_on "openjdk" => :test
  depends_on "python@3.11"

  resource "homebrew-testdata" do
    url "https://github.com/oracle/graal/archive/refs/tags/vm-22.3.0.tar.gz"
    sha256 "410a003b8bab17af86fbc072d549e02e795b862a8396d08af9794febee17bad4"
  end

  def install
    libexec.install Dir["*"]
    (bin/"mx").write_env_script libexec/"mx", MX_PYTHON: "#{Formula["python@3.11"].opt_libexec}/bin/python"
    bash_completion.install libexec/"bash_completion/mx" => "mx"
  end

  def post_install
    # Run a simple `mx` command to create required empty directories inside libexec
    Dir.mktmpdir do |tmpdir|
      system bin/"mx", "--user-home", tmpdir, "version"
    end
  end

  test do
    ENV["JAVA_HOME"] = Language::Java.java_home
    ENV["MX_ALT_OUTPUT_ROOT"] = testpath

    testpath.install resource("homebrew-testdata")
    cd "vm" do
      output = shell_output("#{bin}/mx suites")
      assert_match "distributions:", output
    end
  end
end
