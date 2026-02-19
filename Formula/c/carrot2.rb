class Carrot2 < Formula
  desc "Search results clustering engine"
  homepage "https://search.carrot2.org/"
  url "https://github.com/carrot2/carrot2.git",
      tag:      "release/4.8.4",
      revision: "0f03127e58a6a10a8d0f5f0a0c4807f0f9e5b6cd"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "42fba9ccb181cbecc379c25e36212abbe2ceb0a3c2a5dc931874f50c76e3e83a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "119098d2b7b04c96ed7f0853671d9bd9913a5181fea3176c0e16c5780aeecd63"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1a917893929339e7fe46e84e895f6c45f4b128dad85d2863cb8d10080692f8b2"
    sha256 cellar: :any_skip_relocation, sonoma:        "a96c3308d3758c16b4ec0819ae66bde55503e69620f2ce56ee9054d8f7e34e7d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6b71e7f3e5a5b9adcaf46e0f69d6251b00daf2fdd461b2c76047d505a120d675"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "92af6e592c552ba28bbe9397ff5e6036e0aad737cc5538f1d1c938d915e41e76"
  end

  depends_on "gradle" => :build
  depends_on "node@22" => :build
  depends_on "yarn" => :build
  depends_on "openjdk"

  on_linux do
    on_arm do
      depends_on "python-setuptools" => :build
    end
  end

  def install
    # Make possible to build the formula with the latest available in Homebrew gradle
    inreplace "gradle/wrapper/gradle-wrapper.properties", "gradle-9.2.1", "gradle-#{Formula["gradle"].version}"

    # Use yarn and node from Homebrew
    inreplace "gradle/node/yarn-projects.gradle", "download = true", "download = false"
    inreplace "gradle/libs.versions.toml" do |s|
      s.gsub! "node = \"18.18.2\"", "node = \"#{Formula["node@22"].version}\""
      s.gsub! "yarn = \"1.22.19\"", "yarn = \"#{Formula["yarn"].version}\""
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
    spawn bin/"carrot2", "--port", port.to_s
    sleep 20
    assert_match "Lingo", shell_output("curl -s localhost:#{port}/service/list")
  end
end
