class Carrot2 < Formula
  desc "Search results clustering engine"
  homepage "https://search.carrot2.org/"
  url "https://github.com/carrot2/carrot2.git",
      tag:      "release/4.8.1",
      revision: "102ecc3d83e95cb2fefe061116f0b01882a6d2ec"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b77994d21611ad449336ac8595c49466d0b88ff43a4cde75652aeb149f2a264b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "14bb225f30be22eb91287e80e02350c1993587ff2c61c4fac3a5f7e38332729e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4667e867fdc53456269c94885a150b8e2cf0f5b9f87d79d235e031a9f11a51c0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6e738ae94bcd072d42f41c4ab3be0a702a43ab7135ccb0cec766c385f6376c86"
    sha256 cellar: :any_skip_relocation, sonoma:        "0ef9dac90b90a3607ca5e98e9668dcaec5755658c3c24523862c14f3c52fce52"
    sha256 cellar: :any_skip_relocation, ventura:       "3378de48381ca0794ebef99173884faa190fd15871c6d9431c5b5f6364d51988"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4b9bf87ecc619295a91aa4e6a74e33d9f2ecc6f7078fdbe399ad832c3c911b03"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2a640419faa82a316a67876291de8cab8999c1683bdce397fa77b681db12f87e"
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
