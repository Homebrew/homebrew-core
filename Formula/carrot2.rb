class Carrot2 < Formula
  desc "Search results clustering engine"
  homepage "https://search.carrot2.org/"
  url "https://github.com/carrot2/carrot2.git",
      tag:      "release/4.5.0",
      revision: "cc33e2022a473ecb0a3c6f28b5ce19ad496f13b3"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "467de1d1579ebfe1971aaf839c7b7e4edc41160c29aaefb9b15bf9f723651954"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a7c56bcc050c1d7d4e1f1449790e903947076f95eb7cdaf31597702fc1ff8429"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7f6033e34079c44b323e8b1adf5d9abd0c4170e21f79e07045a7efa9cbd8ae9f"
    sha256 cellar: :any_skip_relocation, ventura:        "d1c7f08c90eadf7c82301cd7511b30ec3b15daa5d8e3555e0b88579144b8a28d"
    sha256 cellar: :any_skip_relocation, monterey:       "7648fa1f8f16a8a1fad02bc03307f704db37e6ca0df56a7afba11410c2c2d74d"
    sha256 cellar: :any_skip_relocation, big_sur:        "80623d35329d07a22074eb202bf33a7d720b7db3a7e22f3bde60b8b43d2d41cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bd0e863984e0d449b62d5a7b80005956bb5b87570d0959bacf781ac09432b9f4"
  end

  depends_on "gradle@7" => :build
  depends_on "node@18" => :build
  depends_on "yarn" => :build
  depends_on "openjdk"

  def install
    # Make possible to build the formula with the latest available in Homebrew gradle
    inreplace "gradle/validation/check-environment.gradle",
      /expectedGradleVersion = '[^']+'/,
      "expectedGradleVersion = '#{Formula["gradle@7"].version}'"

    # Use yarn and node from Homebrew
    inreplace "gradle/node/yarn-projects.gradle", "download = true", "download = false"
    inreplace "build.gradle" do |s|
      s.gsub! "node: '16.13.0'", "node: '#{Formula["node@18"].version}'"
      s.gsub! "yarn: '1.22.15'", "yarn: '#{Formula["yarn"].version}'"
    end

    # Fix `jflex` dependency resolution.
    jflex_regex = /^de\.jflex:jflex=(.*?)\r?$/
    jflex_version = (buildpath/"versions.props").read
                                                .lines
                                                .grep(jflex_regex)
                                                .first[jflex_regex, 1]
    inreplace "gradle/jflex.gradle",
      'jflex "de.jflex:jflex"',
      "jflex \"de.jflex:jflex:#{jflex_version}\""

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
