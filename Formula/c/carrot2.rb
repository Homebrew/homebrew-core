class Carrot2 < Formula
  desc "Search results clustering engine"
  homepage "https://search.carrot2.org/"
  url "https://github.com/carrot2/carrot2.git",
      tag:      "release/4.7.0",
      revision: "fd0b5a95214679f919746ab5abd710bc900d38ec"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8505f9e8705f5ea76bc89b97c5bd60ffddef803b264a5b8cab3bfb5ae8003b04"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0bd1dbc9d3f30887969ce843f247f57b46bb61dae183a5cfe3309e423785aea1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fa5490737cffb2ae8488638366d36492fe627c66b5fd8bd809dd3691b0abeb4e"
    sha256 cellar: :any_skip_relocation, sonoma:        "65ea6538108151a266a7d5340dc9dc35e4d9b4be2ea6d5606eb12ec61da48056"
    sha256 cellar: :any_skip_relocation, ventura:       "75cd64e09c6fd8ab640ac384fa164b3ef73966841f8cf92c3cf7f3c6a4f001f3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "88dbb18f8c9e2982352181b661aa5a4152a9684ce23138ac45e709cd6fbd11e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8e3ab954cc93844a645a59d5ff4840c69dcd915d1c13e5812a26645ec57faae0"
  end

  depends_on "gradle" => :build
  depends_on "node@22" => :build
  depends_on "yarn" => :build
  depends_on "openjdk@21"

  on_linux do
    on_arm do
      depends_on "python-setuptools" => :build
    end
  end

  def install
    # Make possible to build the formula with the latest available in Homebrew gradle
    inreplace "gradle/validation/check-environment.gradle",
      /expectedGradleVersion = '[^']+'/,
      "expectedGradleVersion = '#{Formula["gradle"].version}'"

    # Use yarn and node from Homebrew
    inreplace "gradle/node/yarn-projects.gradle", "download = true", "download = false"
    inreplace "versions.toml" do |s|
      s.gsub! "node = \"18.18.2\"", "node = \"#{Formula["node@22"].version}\""
      s.gsub! "yarn = \"1.22.19\"", "yarn = \"#{Formula["yarn"].version}\""
    end

    system "gradle", "assemble", "--no-daemon"

    cd "distribution/build/dist" do
      inreplace "dcs/conf/logging/appender-file.xml", "${dcs:home}/logs", var/"log/carrot2"
      libexec.install Dir["*"]
    end

    (bin/"carrot2").write_env_script "#{libexec}/dcs/dcs",
      JAVA_CMD:    "exec '#{Formula["openjdk@21"].opt_bin}/java'",
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
