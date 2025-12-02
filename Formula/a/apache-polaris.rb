class ApachePolaris < Formula
  desc "Interoperable, open source catalog for Apache Iceberg"
  homepage "https://polaris.apache.org/"
  url "https://github.com/apache/polaris/archive/refs/tags/apache-polaris-1.1.0-incubating.tar.gz"
  sha256 "cc4e0557e7a9cc36fd0d72412842f11cbbf5acb90f13f6e32fac14aa5f9ed77c"
  license "Apache-2.0"

  livecheck do
    url "https://polaris.apache.org/downloads/"
    regex(/href=.*?apache-polaris-(\d+(?:\.\d+)+)-incubating\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b7be0de8249bc27a87b9450036e69f9563476437f2627176371caba2043e471c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e06628ed638db4c7cc23537fc8ce8f455105dacacd922a2f78c9d735c38dacea"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c9446b5bc0c4ea66d04e1295ca6d29744c62b34d37a920142bcf48e3e9fb1356"
    sha256 cellar: :any_skip_relocation, sonoma:        "46cebbbc97ec05299f795dd61bc8e4351134fa1918e3e56e6401be68b9d48de9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d73af81b82333cc0c6899e6446c469ecaa98a702823e6f79698b988950814432"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c455b85be6a394de94a20a4e6badb785e93f791cd730a6782e44c84c904006d6"
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
