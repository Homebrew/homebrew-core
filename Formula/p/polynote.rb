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
    rebuild 1
    sha256 cellar: :any, arm64_tahoe:   "83a7b0af49ba4ab4ad4da51b15ffe2e9609cda61d2027f566d97d87461557974"
    sha256 cellar: :any, arm64_sequoia: "4747bf5c546668f894b6fe33984237f7dd1bd6bb90220df4923797f670b014ee"
    sha256 cellar: :any, arm64_sonoma:  "1ee1662e8ef70df9244d5d4bff9df24ab2ac50c06871f1ee77902a4453f41dc3"
    sha256 cellar: :any, sonoma:        "987e62d3b5ccf2d0bf0b3d7055628478d3b8fcd4d7ad889c13c8fa9aff6ded02"
    sha256               arm64_linux:   "426f9eafe5932f3b4e48f8dcab47ea25b0af7c7683fb3f7c814d27439dd2bd09"
    sha256               x86_64_linux:  "6815b22885a9e13f6d381db68b8bddc4249786d2f33bacd98ef95df6a9bcb8ca"
  end

  depends_on "numpy" # used by `jep` for Java primitive arrays
  depends_on "openjdk"
  depends_on "python@3.14"

  resource "jep" do
    url "https://files.pythonhosted.org/packages/0e/92/994ae1013446f26103e9ff71676f4c96a7a6c0a9d6baa8f12805884f7b5e/jep-4.2.2.tar.gz"
    sha256 "4eb79d903133e468c239ba39c8bb5ade021ef202025bf1c9b34a210003e0eab9"
  end

  def install
    python3 = "python3.14"

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
