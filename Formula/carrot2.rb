class Carrot2 < Formula
  desc "Search results clustering engine"
  homepage "https://search.carrot2.org/"
  url "https://github.com/carrot2/carrot2.git",
      tag:      "release/4.5.1",
      revision: "038e308d423f0b8ed6545ae6dbf492dabf63440a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f50a4f1026e2eb94d7e3faafab86eb919a5891b2f06a5a125d3b7e2d83837611"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a8d887e0acd31241dd2b6a8bf85e9e3af07e13c72bf0b0f494534a129cbdd59c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "76395cdf9b6e2c7e582cbcdfe1b233f8eec034110fb8f1d3aa2fabf8c734e85b"
    sha256 cellar: :any_skip_relocation, ventura:        "8a95a1d07e88868d665adcd2f580364014b319c37a80e81ca5003e111b7cefcd"
    sha256 cellar: :any_skip_relocation, monterey:       "8aa1bd4b486da634beabdef5f7ac2814dacff5354db8e00c2a7f528f723958e7"
    sha256 cellar: :any_skip_relocation, big_sur:        "94b72f4e60130a83ca992e58cb25377b835b713782a65a9900bf13b3fa616ab6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ead48aad206f091a6bf53c0b467e8127a50240ee3d4a6e01c9784299a03695fa"
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
