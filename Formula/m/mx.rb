class Mx < Formula
  desc "Command-line tool used for the development of Graal projects"
  homepage "https://github.com/graalvm/mx"
  url "https://github.com/graalvm/mx/archive/refs/tags/7.89.0.tar.gz"
  sha256 "48b6f919a3697a0ca4fb367ea8b9539eae505da2c05cfc163f28b3bf1059c1c1"
  license "GPL-2.0-only"
  compatibility_version 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    manifest_sha256 "7a1fbce0c1e3316b8212f50695673fd78f69569d828716faaf94204d7ae3cd56"
    sha256 cellar: :any_skip_relocation, all: "17fdd79f10a4128a1ec2c186765f4dc5aeda32e7775cb98364c7cd407ab17c40"
  end

  depends_on "openjdk" => [:build, :test]
  depends_on "python@3.15"

  resource "homebrew-testdata", :test do
    url "https://github.com/oracle/graal/archive/refs/tags/vm-25.0.2.tar.gz"
    sha256 "129261a9c43d43ca8cad235b65ee9cf8bfa9a2e2d51e90ac188e3cf5174323a0"
  end

  def install
    libexec.install Dir["*"]
    (bin/"mx").write_env_script libexec/"mx", MX_PYTHON: python3
    bash_completion.install libexec/"bash_completion/mx" => "mx"

    # Run a simple `mx` command to create required directories inside libexec
    ENV["JAVA_HOME"] = Language::Java.java_home
    ENV.remove "PATH", Superenv.shims_path # avoid ninja shim
    system bin/"mx", "version"
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
