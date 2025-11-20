class Carrot2 < Formula
  desc "Search results clustering engine"
  homepage "https://search.carrot2.org/"
  url "https://github.com/carrot2/carrot2.git",
      tag:      "release/4.8.3",
      revision: "e2e57a553b8d6015af23f43dfff245157a267bc8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "851efb7ea413d096ad2ff96f9d2f726507065f8107922af401a87b7d65b8edce"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "526625534a78b14fce2023d2927daec0b69b114c8974d4a868f3aafeeb935b47"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8f977963b7a9c05ccf28d598b03b9ea585ab185613a314122ac39fbb74114a93"
    sha256 cellar: :any_skip_relocation, sonoma:        "6afd51b10e424be4f15eba55fc0458ab9146b7d9c9e6244a4c48cc36ed73fe18"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1f457acbc704c8bf66dbcec5cb24d44017f572fe88187536ecc2d363204d24f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "73d0c05cf12b9da21aae87335be309884c8c682f65195ac31872176a5b9da2a8"
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
    inreplace "gradle/wrapper/gradle-wrapper.properties", "gradle-8.14", "gradle-#{Formula["gradle"].version}"

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
