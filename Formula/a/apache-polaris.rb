class ApachePolaris < Formula
  desc "Interoperable, open source catalog for Apache Iceberg"
  homepage "https://polaris.apache.org/"
  url "https://github.com/apache/polaris/archive/refs/tags/apache-polaris-1.0.1-incubating.tar.gz"
  sha256 "d4af0da781fa87cf67e4136e4cf51f0a54c5eac674a96bd8b1016713e86feac7"
  license "Apache-2.0"

  livecheck do
    url "https://polaris.apache.org/downloads/"
    regex(/href=.*?apache-polaris-(\d+(?:\.\d+)+)-incubating\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b7229485f96735caac813d019d79098e3df2e56d4e8106809498d00b9e36e98c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "da5faeee880b6153d66bc8ee21c8a8f6416f3e347ba86a9bb9c834cf83e546b1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5366a37b9efc409f116e4a2d358bb738af3db29a1a7686061710aecc345710c6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "311897ec4dffc9fab438e6c5a218beb7ab9bff375955c762a3f0a3bc00eafc60"
    sha256 cellar: :any_skip_relocation, sonoma:        "b59812aa643d05ca91a41285d00517e10f86b608ad52bc28635b0b2b9a2c5a43"
    sha256 cellar: :any_skip_relocation, ventura:       "76be671bcdb881834bcdf0e37e76ffe14f0e2f6d461dbeb1a651fda87d79575a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ab62b3cac6dce28eb04a2fdcd94a0baddcb1f8c0c903c908baf541afb69dcc0b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e52ea97e219a2d15c7b7316301d94ae17b1e804ea7a923871660b10483c44e28"
  end

  depends_on "gradle@8" => :build
  depends_on "openjdk"

  def install
    system "gradle", "assemble"

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
