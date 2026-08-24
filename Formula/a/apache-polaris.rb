class ApachePolaris < Formula
  desc "Interoperable, open source catalog for Apache Iceberg"
  homepage "https://polaris.apache.org/"
  url "https://github.com/apache/polaris/archive/refs/tags/apache-polaris-1.7.0.tar.gz"
  sha256 "cd56c1fd62d07a76154ca3805104b7a6fa947a6b6e38b90b7f14164c32f81659"
  license "Apache-2.0"

  livecheck do
    url "https://polaris.apache.org/downloads/"
    regex(%r{href=.*?/releases/v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b41354d7b5fc5fda3755221cc93235bed8334dcb77f684096215aa9265eab37b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0fbeb6817dd7a3ca6f9da1b3bafa5fb17f6be3e26997aad5d9374cec3a8f4d06"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ac3905955df79d3a47de408d83bc2087f74f5949062698aa2ba4a57cdcb5791f"
    sha256 cellar: :any_skip_relocation, sonoma:        "279fec0e998bb1a3249194ab00a185f983f89bfa429c1aba5dea15f61a7ef6c9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bec49597ed014ddc8ab9c25b604c10de95cde452091f4c02e245cb4baa5b8f93"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9d2ce0bcb01e2b9d0b43181ca510c86919b864c1e6824349dc62a0a111311095"
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
