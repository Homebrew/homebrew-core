class ApachePolaris < Formula
  desc "Interoperable, open source catalog for Apache Iceberg"
  homepage "https://polaris.apache.org/"
  url "https://github.com/apache/polaris/archive/refs/tags/apache-polaris-1.3.0-incubating.tar.gz"
  sha256 "4a502ceb521c09a179d8a4e0f6b75ff0b76b60b707179df9535b2553a9585032"
  license "Apache-2.0"

  livecheck do
    url "https://polaris.apache.org/downloads/"
    regex(/href=.*?apache-polaris-(\d+(?:\.\d+)+)-incubating\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7fb75b040fe393a5b225af7ce9779e619a500f55bc87a75081bf824047e8510e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fb407f578efa1ebb8693505fefaa0f810d2f8af8b6e9971b1506e6d0e648ce86"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1b9392a0b73ea4056e3b955f92ae2c152d32db3c3df49d52db14caea444c081c"
    sha256 cellar: :any_skip_relocation, sonoma:        "e56e2613dd258ec7ee6c2029a038fed632320f207256081159177a81c98ecfc3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "35ab94550957709bdaa5443e748d94a9821fa7d09ff91c7ce2d508c5f982e9d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "560c8e1e3afc88b55ff8f0f6995c6d997ba53c856dcc79730e4b0671f1536fcb"
  end

  depends_on "gradle" => :build
  depends_on "openjdk"

  def install
    ENV.delete "CI" # work around Gradle stalling on macOS CI runners

    system "gradle", "assemble", "--no-daemon"

    mkdir "build" do
      system "tar", "xzf", "../runtime/distribution/build/distributions/polaris-bin-#{version}-incubating.tgz", "--strip-components", "1"
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
    spawn bin/"polaris-server"

    output = shell_output("curl -s --retry 5 --retry-connrefused localhost:#{port}/q/health")
    assert_match "UP", output
  end
end
