class ApachePolaris < Formula
  desc "Interoperable, open source catalog for Apache Iceberg"
  homepage "https://polaris.apache.org/"
  url "https://github.com/apache/polaris/archive/refs/tags/apache-polaris-1.6.0.tar.gz"
  sha256 "9c265e559eb9a82bee2c684f11cf3be8cc1e907f6a2955a280401c4876020840"
  license "Apache-2.0"

  livecheck do
    url "https://polaris.apache.org/downloads/"
    regex(%r{href=.*?/releases/v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "453f69cb7b207705a0a3ca91c3eff5a890c363425db257eeb656532fcbe42227"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "632ca6a198eb14c8005225a0b1c608929620270ba47caaaf0f52deb27c07a613"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ae69a2bc1e5b2153a1305114f2181c3eb1ab86a521c8291f066f6f4f28cead95"
    sha256 cellar: :any_skip_relocation, sonoma:        "48cae1036eb5f28e462cd93fc913ba4b31ea9caeabc73f2f2a8125f9c6b5a693"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "59c792c1151679f93626b353b362bc2cde30ccf02aae2f192aa36e8892466a8a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f166ea2062936471fe427e8ff073e775a5838d3e13c4109052158e06ee530434"
  end

  depends_on "gradle" => :build
  depends_on "openjdk"

  def install
    ENV.delete "CI" # work around Gradle stalling on macOS CI runners

    system "gradle", "assemble", "--no-daemon"

    mkdir "build" do
      system "tar", "xzf", "../runtime/distribution/build/distributions/polaris-bin-#{version}.tgz", "--strip-components", "1"
      libexec.install "admin", "bin", "server"
    end

    java_env = Language::Java.overridable_java_home_env
    %w[admin server].each do |script|
      (bin/"polaris-#{script}").write_env_script libexec/"bin"/script, java_env
    end
  end

  service do
    run [opt_bin/"polaris-server"]
    keep_alive true
    error_log_path var/"log/polaris.log"
    log_path var/"log/polaris.log"
  end

  test do
    port = free_port
    ENV["QUARKUS_HTTP_PORT"] = free_port.to_s
    ENV["QUARKUS_MANAGEMENT_PORT"] = port.to_s
    pid = spawn bin/"polaris-server"

    output = shell_output("curl -s --retry 5 --retry-connrefused localhost:#{port}/q/health")
    assert_match "UP", output
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
