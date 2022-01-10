class Carrot2 < Formula
  desc "Search results clustering engine"
  homepage "https://search.carrot2.org/"
  url "https://github.com/carrot2/carrot2.git",
      tag:      "release/4.4.2",
      revision: "33dbd68df542e32700e42b930a75e29d1e64ee83"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fd9af8fb197f3899ca86a997be76f214d71ec7653002442f6e6c85e5087064f6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4b20d930f9810dcbbd60534b84d7ed928a7fe39419c92eb6601798dcbcf86b98"
    sha256 cellar: :any_skip_relocation, monterey:       "77cff0fab82a213b316fda870e9d7c3e9307a7357ba81bbf08519a7f42969d88"
    sha256 cellar: :any_skip_relocation, big_sur:        "1d21bcc5fade38c8d8618002e1fdf9e9c3d06e23c7202553ecfc5fe81f966072"
    sha256 cellar: :any_skip_relocation, catalina:       "fa27ece482d74ebbb9db210877252124e61997facdc4087a5f8a33dd8c6471f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "53bc7e87ee4131bab1e39ad4f3020fd5d0f8d6f419039196fceb2000f1d8a554"
  end

  depends_on "gradle" => :build
  depends_on "node@16" => :build
  depends_on "yarn" => :build
  depends_on "openjdk"

  def install
    # Make possible to build the formula with the latest available in Homebrew gradle
    inreplace "gradle/validation/check-environment.gradle",
      /expectedGradleVersion = '[^']+'/,
      "expectedGradleVersion = '#{Formula["gradle"].version}'"

    # Use yarn and node from Homebrew
    inreplace "gradle/node/yarn-projects.gradle", "download = true", "download = false"
    inreplace "build.gradle" do |s|
      s.gsub! "node: '16.13.0'", "node: '#{Formula["node@16"].version}'"
      s.gsub! "yarn: '1.22.15'", "yarn: '#{Formula["yarn"].version}'"
    end

    system "gradle", "assemble", "--no-daemon"

    cd "distribution/build/dist" do
      inreplace "dcs/conf/logging/appender-file.xml", "${dcs:home}/logs", var/"log/carrot2"
      libexec.install Dir["*"]
    end

    (bin/"carrot2").write_env_script "#{libexec}/dcs/dcs",
      JAVA_CMD:    "exec '#{Formula["openjdk"].opt_bin}/java'",
      SCRIPT_HOME: libexec/"dcs"
  end

  service do
    run opt_bin/"carrot2"
    working_dir opt_libexec
  end

  test do
    port = free_port
    fork { exec bin/"carrot2", "--port", port.to_s }
    sleep 20
    assert_match "Lingo", shell_output("curl -s localhost:#{port}/service/list")
  end
end
