class Carrot2 < Formula
  desc "Search results clustering engine"
  homepage "https://search.carrot2.org/"
  url "https://github.com/carrot2/carrot2.git",
      tag:      "release/4.6.0",
      revision: "a29bd71366f2ac3c135ee1a9cb9da3748954e088"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "42cb2196e42f3dcad47280ea9bd1e744084f0f68a609f39c9537c9f84900fa6d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "63b10879de0b38414b6d3d0a77a7d1301d43e877f41e6c5a3f593f71da12378a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "baf90c58c0de1fb56ec3d47d263ca2b2fd5596d26bd31cb5bd23f0000e7e94ac"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e2b5d97a750dae863513da210590e6f182c83c77e8485b4af3090d52002ca65f"
    sha256 cellar: :any_skip_relocation, sonoma:         "7d8d893393a220446ab0409b49350cd3c1b51e223671eb10b5ad235905d4df01"
    sha256 cellar: :any_skip_relocation, ventura:        "7172200db6bf11abff4c0eb13e4b8ca9a1aebe11fd86d36c7c946c9e82be19a5"
    sha256 cellar: :any_skip_relocation, monterey:       "bea99b1b19f45ac46a26d418ecd07f79a099e69aafe2c9a027223e5c0bdbbedf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d8441898809575d62112c43a0662bb50171bc5492ff80ce451a6dd2b51a412ee"
  end

  depends_on "gradle" => :build
  depends_on "node" => :build
  depends_on "yarn" => :build
  depends_on "openjdk@21"

  def install
    # Make possible to build the formula with the latest available in Homebrew gradle
    inreplace "gradle/validation/check-environment.gradle",
      /expectedGradleVersion = '[^']+'/,
      "expectedGradleVersion = '#{Formula["gradle"].version}'"

    # Use yarn and node from Homebrew
    inreplace "gradle/node/yarn-projects.gradle", "download = true", "download = false"
    inreplace "versions.toml" do |s|
      s.gsub! "node = \"18.18.2\"", "node = \"#{Formula["node"].version}\""
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
