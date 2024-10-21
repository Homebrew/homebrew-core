class Polynote < Formula
  include Language::Python::Shebang

  desc "Polyglot notebook with first-class Scala support"
  homepage "https://polynote.org/"
  url "https://github.com/polynote/polynote/releases/download/0.6.0/polynote-dist.tar.gz"
  sha256 "ec4e0e434f5996e83fd9490dbd6b99cbb724a39fa4074d3198eb16662ddf1d4a"
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
    sha256 cellar: :any, arm64_sequoia: "3108301f5ac48280748b5bcb39d3d9a58163c01a746298e0fd52c356f60dce9d"
    sha256 cellar: :any, arm64_sonoma:  "97f65023ac434561f2d6d2805cca4f42d8fd8ebece48db502774abe4451a395d"
    sha256 cellar: :any, arm64_ventura: "099ee95666dab608cb20e6cf0a3ea6deddd2aa068e17f5d4b4a3e81e4a10f2b3"
    sha256 cellar: :any, sonoma:        "023f3ec9fbbf8f609f50f2a5af29a219ad0f92bacaaaab04171ac0336e35749b"
    sha256 cellar: :any, ventura:       "4f615c977c0f8fce74196f5edd3b4b206ecc49642e9488cf429c098633ca052b"
    sha256               x86_64_linux:  "b45a939832aef9806c719241f96371f4672a7f46bb23f04bd672417083cd3038"
  end

  depends_on "numpy" # used by `jep` for Java primitive arrays
  depends_on "openjdk"
  depends_on "python@3.13"

  resource "jep" do
    url "https://files.pythonhosted.org/packages/16/94/3bc40b4683442bd34e7c511cbe5c1a1bb8d5d6de1f4955991a07fe02c836/jep-4.2.0.tar.gz"
    sha256 "636368786b4f3dc29510454e0580a432e45e696de99ce973a3caef6faec35287"
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

    assert_predicate bin/"polynote", :exist?
    assert_predicate bin/"polynote", :executable?

    output = shell_output("#{bin}/polynote version 2>&1", 1)
    assert_match "Unknown command version", output

    port = free_port
    (testpath/"config.yml").write <<~EOS
      listen:
        host: 127.0.0.1
        port: #{port}
      storage:
        dir: #{testpath}/notebooks
    EOS

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
