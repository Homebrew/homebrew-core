class Mx < Formula
  desc "Command-line tool used for the development of Graal projects"
  homepage "https://github.com/graalvm/mx"
  url "https://github.com/graalvm/mx/archive/refs/tags/7.85.1.tar.gz"
  sha256 "475ca3716610e3e98eb4ec4ef0dd9d2a45a089b3344460e802a107ae99cc1f0c"
  license "GPL-2.0-only"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "24721b974551c5ee10947f158c58065e7dfeec1fb6c9e78bda1014b23e48d1bb"
  end

  depends_on "openjdk" => [:build, :test]
  depends_on "python@3.14"

  def install
    libexec.install Dir["*"]
    (bin/"mx").write_env_script libexec/"mx", MX_PYTHON: "#{formula_opt_libexec("python@3.14")}/bin/python"
    bash_completion.install libexec/"bash_completion/mx" => "mx"

    # Run a simple `mx` command to create required directories inside libexec
    ENV["JAVA_HOME"] = Language::Java.java_home
    ENV.remove "PATH", Superenv.shims_path # avoid ninja shim
    system bin/"mx", "version"
  end

  test do
    resource "homebrew-testdata" do
      url "https://github.com/oracle/graal/archive/refs/tags/vm-25.0.2.tar.gz"
      sha256 "129261a9c43d43ca8cad235b65ee9cf8bfa9a2e2d51e90ac188e3cf5174323a0"
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
