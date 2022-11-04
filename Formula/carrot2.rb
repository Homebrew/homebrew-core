class Carrot2 < Formula
  desc "Search results clustering engine"
  homepage "https://search.carrot2.org/"
  url "https://github.com/carrot2/carrot2.git",
      tag:      "release/4.5.0",
      revision: "cc33e2022a473ecb0a3c6f28b5ce19ad496f13b3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "970574065c9b7c64597320fb111a7b3b1a3837edc24b492bc8816f250dcc243e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ec9a0fe76ab5eebb90f2431085383eb8983da4b66545dca29c0d945944a1d32f"
    sha256 cellar: :any_skip_relocation, monterey:       "5b41bac01d5b61f3ec528bf8608db4d83fe2fcc5f75770fc3569d4b6c0f58e62"
    sha256 cellar: :any_skip_relocation, big_sur:        "5a7c58f94e1ca0dc72fdaba9e6dc108b42baed87d2cd006121770a1e11cbe027"
    sha256 cellar: :any_skip_relocation, catalina:       "877c092b2e544c553386b4f8d909a2951b5d26385cd612535bba02815fdb4316"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3b6682bd0a7e1552935a84fc7aa6e87454792ae32659b22174a5f221c94c88f6"
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
