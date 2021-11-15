class ParquetCli < Formula
  desc "Apache Parquet command-line tools and utilities"
  homepage "https://parquet.apache.org/"
  url "https://github.com/apache/parquet-mr.git",
      tag:      "apache-parquet-1.12.0",
      revision: "db75a6815f2ba1d1ee89d1a90aeb296f1f3a8f20"
  license "Apache-2.0"
  head "https://github.com/apache/parquet-mr.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8ec90d31e13d0630ed26cd3da219a448fafb672a4277ee277d8ab4c1e68fabcc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b3c9cf0f2d194f6ea74d86187d07fea91b26a1dba7911d9648eaefa8b6039c6b"
    sha256 cellar: :any_skip_relocation, monterey:       "22799743778180bab374cc78565237689ae3a6405ded0022c46bd156b8f3cd12"
    sha256 cellar: :any_skip_relocation, big_sur:        "a0b9c8859d7dfb3c6e66cef92b191b7a4861338e02be1694ba70f86c646e56db"
    sha256 cellar: :any_skip_relocation, catalina:       "1cd95d2c049e2d049e799f27dda903fb6497d4701f86924fec4ac8470455dae2"
    sha256 cellar: :any_skip_relocation, mojave:         "f1c5eb930f2c094ba7e3ef80856420b01f96ce197705f5da0b39039a54ffa498"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "75ce0a3f58329686ecec3060d3ffd715265cdccfc0f80d443833d2a7bd03b812"
  end

  depends_on "maven" => :build
  depends_on "openjdk"

  # This file generated with `red-parquet` gem:
  #   Arrow::Table.new("values" => ["foo", "Homebrew", "bar"]).save("homebrew.parquet")
  resource("test-parquet") do
    url "https://gist.github.com/bayandin/2144b5fc6052153c1a33fd2679d50d95/raw/7d793910a1afd75ee4677f8c327491f7bdd2256b/homebrew.parquet"
    sha256 "5caf572cb0df5ce9d6893609de82d2369b42c3c81c611847b6f921d912040118"
  end

  def install
    cd "parquet-cli" do
      system "mvn", "clean", "package", "-DskipTests=true"
      system "mvn", "dependency:copy-dependencies"
      libexec.install "target/parquet-cli-#{version}-runtime.jar"
      libexec.install Dir["target/dependency/*"]
      (bin/"parquet").write <<~EOS
        #!/bin/sh
        set -e
        exec "#{Formula["openjdk"].opt_bin}/java" -cp "#{libexec}/*" org.apache.parquet.cli.Main "$@"
      EOS
    end
  end

  test do
    resource("test-parquet").stage testpath

    output = shell_output("#{bin}/parquet cat #{testpath}/homebrew.parquet")
    assert_match "{\"values\": \"Homebrew\"}", output
  end
end
