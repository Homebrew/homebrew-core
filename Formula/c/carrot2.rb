class Carrot2 < Formula
  desc "Search results clustering engine"
  homepage "https://search.carrot2.org/"
  url "https://github.com/carrot2/carrot2.git",
      tag:      "release/4.5.3",
      revision: "f3727694889b258018d4bfdf5523b641d1d389df"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d0fff349cac498699491b5dbb70518e67bbd97a9dd80a965d4aeb605746fd693"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0017146fb1d813c3693ebf0600fb9be1d6f67ac91f7ed95628391b7c469cf254"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "741ee72710b6174a8863ebe6438d74377e1bab20a3c330e671036b1730936783"
    sha256 cellar: :any_skip_relocation, sonoma:         "891fdb5e17c01c9bf70fd14602e6d5973ed0825e28c15a1b54049185d940391d"
    sha256 cellar: :any_skip_relocation, ventura:        "70bd3fc0246ef33fc049e80ba1dfc626da5144faecfd9d76ea2fec4dba087432"
    sha256 cellar: :any_skip_relocation, monterey:       "fb44d3604b798e621b5b3d4fa89ecd4787a0109e832eeeb0fb09b20abdeb9f00"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9aacdd216cef8f6ead96f24359fc46dffcb055cf17578de843d982f502ac0555"
  end

  depends_on "gradle" => :build
  depends_on "node" => :build
  depends_on "yarn" => :build
  depends_on "openjdk"

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
