class Carrot2 < Formula
  desc "Search results clustering engine"
  homepage "https://search.carrot2.org/"
  url "https://github.com/carrot2/carrot2.git",
      tag:      "release/4.8.6",
      revision: "fa471b2f70b2f54afa594fa23f170f3bb6435c6a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "26a2e0710f7f3b0b86af79fd864096a49414fe8d8bb25ab9f077715a0270a7dd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7fb93a44e7da0f3b19e3a4cff6c7263daccf2bb7ebb20ecc96cd8e6d186ea1d2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b14477c06f381620f1e897ef65ce1bff59ad4c34f8cdd07810d8132560f32f02"
    sha256 cellar: :any_skip_relocation, sonoma:        "1894c5d3399c5335ce5726ee51fcc12fbd4d21b3155af2475b8d81af946d11a6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9a2f9dc7f4462db3ef46a5940544d7f83d7d065f0b5e528ae5f5a5c89cde7dc1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f38906fe8f4c2e76336954ef2fc9449e706c29469ea179b78217048e1f64d725"
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
    inreplace "gradle/wrapper/gradle-wrapper.properties", "gradle-9.3.1", "gradle-#{Formula["gradle"].version}"

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
