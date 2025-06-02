class Metals < Formula
  desc "Scala language server"
  homepage "https://github.com/scalameta/metals"
  url "https://github.com/scalameta/metals/archive/refs/tags/v1.5.3.tar.gz"
  sha256 "008a39fd5b8c8589cf6221e3baaf887cab4f3c7554a7be91a875b02cf1da9578"
  license "Apache-2.0"

  # Some version tags don't become a release, so it's necessary to check the
  # GitHub releases instead.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5d375d0d8813da31c2f4bc9a1ec5799fea294f1f1bc88b1ed4dc5b6d93cf1d53"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2e6bbdd1472833d5412bebcf5af842c85dcf30319c49d5fbd87fe3ceb41c22f4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "147516fe36c60676aa1923d958ea50e3f8b572fdfa8b6109a83eca3134683847"
    sha256 cellar: :any_skip_relocation, sonoma:        "11cd8d503e6dcc3193aa69cbdfed6068bfc9ff8d6b60c6d089b4c449a447d30a"
    sha256 cellar: :any_skip_relocation, ventura:       "daf54b479006a2a8b59760297593649bea3589f5c7a6cf4de8cbf6d44531157a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6b0853607504f74c18109afda0b65d62ce439d3b11fb3d575cfc694d4a80ba0f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ba54ad830ad08452908417651cfec07ca8c4d83b75ac9d5a79533e6d0cb09e14"
  end

  depends_on "sbt" => :build
  depends_on "openjdk"

  def install
    ENV["CI"] = "TRUE"
    inreplace "build.sbt", /version ~=.+?,/m, "version := \"#{version}\","

    system "sbt", "package"

    # Following Arch AUR to get the dependencies.
    dep_pattern = /^.+?Attributed\((.+?\.jar)\).*$/
    sbt_deps_output = Utils.safe_popen_read("sbt 'show metals/dependencyClasspath' 2>/dev/null")
    deps_jars = sbt_deps_output.lines.grep(dep_pattern) { |it| it.strip.gsub(dep_pattern, '\1') }
    deps_jars.each do |jar|
      (libexec/"lib").install jar
    end

    (libexec/"lib").install buildpath.glob("metals/target/scala-*/metals_*-#{version}.jar")
    (libexec/"lib").install buildpath.glob("mtags/target/scala-*/mtags_*-#{version}.jar")
    (libexec/"lib").install buildpath.glob("mtags-shared/target/scala-*/mtags-shared_*-#{version}.jar")
    (libexec/"lib").install "mtags-interfaces/target/mtags-interfaces-#{version}.jar"

    args = %W[-cp "#{libexec/"lib"}/*" scala.meta.metals.Main]
    env = Language::Java.overridable_java_home_env
    env["PATH"] = "$JAVA_HOME/bin:$PATH"
    (bin/"metals").write_env_script "java", args.join(" "), env
  end

  test do
    require "open3"
    json = <<~JSON
      {
        "jsonrpc": "2.0",
        "id": 1,
        "method": "initialize",
        "params": {
          "rootUri": null,
          "capabilities": {}
        }
      }
    JSON
    Open3.popen3(bin/"metals") do |stdin, stdout, _e, w|
      stdin.write "Content-Length: #{json.size}\r\n\r\n#{json}"
      sleep 3
      assert_match(/^Content-Length: \d+/i, stdout.readline)
      Process.kill("KILL", w.pid)
    end
  end
end
