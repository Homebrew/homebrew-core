class Polynote < Formula
  include Language::Python::Shebang

  desc "Polyglot notebook with first-class Scala support"
  homepage "https://polynote.org/"
  url "https://github.com/polynote/polynote/releases/download/0.6.1/polynote-dist.tar.gz"
  sha256 "3d460e6929945591b6781ce11b11df8eebbfb9b6f0b3203861e70687c3eca3a1"
  license "Apache-2.0"

  # Upstream marks all releases as "pre-release", so we have to use
  # `GithubReleases` to be able to match pre-release releases until there's a
  # "latest" release for us to be able to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:[.-]\d+)+)$/i)
    strategy :github_releases do |json, regex|
      json.map do |release|
        next if release["draft"] # || release["prerelease"]

        match = release["tag_name"]&.match(regex)
        next if match.blank?

        match[1]
      end
    end
  end

  bottle do
    sha256 cellar: :any, arm64_sequoia: "9b2efac6f87a4b3c29b2d12a93fffa42f2198d8836ef438ef1e56e40332601f2"
    sha256 cellar: :any, arm64_sonoma:  "70cfaab129c7d151d28295af6ed37ce251b2a37b619cde49ec20b5325309226b"
    sha256 cellar: :any, arm64_ventura: "b7d8fe06b593b1b8ee381b6b28d64a6202db69ddb988ac46fef84886bfac5725"
    sha256 cellar: :any, sonoma:        "07716c02135db664f847fbb3c85676582729d19218ab3bbef44a0f6903debf52"
    sha256 cellar: :any, ventura:       "3364fdd8e9136617db7a9a647e2175ff16e215cc18bfd85a67c007ce581cd2d3"
    sha256               arm64_linux:   "ee7e85ff4e412dbad97ac25b161252099eb1a90c82863e4e4f1a87f9622cf5d8"
    sha256               x86_64_linux:  "a62217d545dcbb8a7944defde2cade6f1dc802478f10749a688f370e19d0dc4e"
  end

  depends_on "numpy" # used by `jep` for Java primitive arrays
  depends_on "openjdk"
  depends_on "python@3.13"

  resource "jep" do
    url "https://files.pythonhosted.org/packages/0e/92/994ae1013446f26103e9ff71676f4c96a7a6c0a9d6baa8f12805884f7b5e/jep-4.2.2.tar.gz"
    sha256 "4eb79d903133e468c239ba39c8bb5ade021ef202025bf1c9b34a210003e0eab9"
  end

  def install
    python3 = "python3.13"

    with_env(JAVA_HOME: Language::Java.java_home) do
      resource("jep").stage do
        # Help native shared library in jep resource find libjvm.so on Linux.
        unless OS.mac?
          ENV.append "LDFLAGS", "-L#{Formula["openjdk"].libexec}/lib/server"
          ENV.append "LDFLAGS", "-Wl,-rpath,#{Formula["openjdk"].libexec}/lib/server"
        end

        system python3, "-m", "pip", "install", *std_pip_args(prefix: libexec/"vendor", build_isolation: true), "."
      end
    end

    libexec.install Dir["*"]
    rewrite_shebang detected_python_shebang, libexec/"polynote.py"

    env = Language::Java.overridable_java_home_env
    env["PYTHONPATH"] = libexec/"vendor"/Language::Python.site_packages(python3)
    env["LD_LIBRARY_PATH"] = lib
    (bin/"polynote").write_env_script libexec/"polynote.py", env
  end

  test do
    mkdir testpath/"notebooks"

    assert_path_exists bin/"polynote"
    assert_predicate bin/"polynote", :executable?

    output = shell_output("#{bin}/polynote version 2>&1", 1)
    assert_match "Unknown command version", output

    port = free_port
    (testpath/"config.yml").write <<~YAML
      listen:
        host: 127.0.0.1
        port: #{port}
      storage:
        dir: #{testpath}/notebooks
    YAML

    begin
      pid = fork do
        exec bin/"polynote", "--config", "#{testpath}/config.yml"
      end
      sleep 5

      assert_match "<title>Polynote</title>", shell_output("curl -s 127.0.0.1:#{port}")
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
