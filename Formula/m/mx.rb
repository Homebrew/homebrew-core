class Mx < Formula
  desc "Command-line tool used for the development of Graal projects"
  homepage "https://github.com/graalvm/mx"
  url "https://github.com/graalvm/mx/archive/refs/tags/7.25.10.tar.gz"
  sha256 "6e8d420cc69d436b479619c0be3df49a6cb83c64892946effc0754dc583acddd"
  license "GPL-2.0-only"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "49f6b9aa9fd4d5de00bebe039cad73ceeb57db3901af208fbf062b6ba0ca6c90"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "49f6b9aa9fd4d5de00bebe039cad73ceeb57db3901af208fbf062b6ba0ca6c90"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "49f6b9aa9fd4d5de00bebe039cad73ceeb57db3901af208fbf062b6ba0ca6c90"
    sha256 cellar: :any_skip_relocation, sonoma:         "f62f8b2c5f195378903cd3778245a962e9ce1c7a5ff784bf106690e694215ddb"
    sha256 cellar: :any_skip_relocation, ventura:        "f62f8b2c5f195378903cd3778245a962e9ce1c7a5ff784bf106690e694215ddb"
    sha256 cellar: :any_skip_relocation, monterey:       "49f6b9aa9fd4d5de00bebe039cad73ceeb57db3901af208fbf062b6ba0ca6c90"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9f129e72af8b983c18d0645af769a77b9dfafea677344b1eac9194ae0492d60c"
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
