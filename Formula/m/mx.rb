class Mx < Formula
  desc "Command-line tool used for the development of Graal projects"
  homepage "https://github.com/graalvm/mx"
  url "https://github.com/graalvm/mx/archive/refs/tags/7.75.0.tar.gz"
  sha256 "9b9ece1b7839685f92af04722d335b8b4c2da3e3f1188505773bde2f57f92a4d"
  license "GPL-2.0-only"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "7edc7ef6ef5d3f12ced26aec7685ef9c9bd9e0f7d56500061d7ffd7fbabe8a23"
  end

  depends_on "openjdk" => [:build, :test]
  depends_on "python@3.14"

  def install
    libexec.install Dir["*"]
    (bin/"mx").write_env_script libexec/"mx", MX_PYTHON: "#{Formula["python@3.14"].opt_libexec}/bin/python"
    bash_completion.install libexec/"bash_completion/mx" => "mx"

    # Run a simple `mx` command to create required directories inside libexec
    ENV["JAVA_HOME"] = Language::Java.java_home
    ENV.remove "PATH", Superenv.shims_path # avoid ninja shim
    chmod 0555, bin/"mx"
    system bin/"mx", "version"
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
