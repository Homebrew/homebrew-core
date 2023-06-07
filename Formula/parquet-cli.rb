class ParquetCli < Formula
  desc "Apache Parquet command-line tools and utilities"
  homepage "https://parquet.apache.org/"
  url "https://github.com/apache/parquet-mr.git",
      tag:      "apache-parquet-1.13.1",
      revision: "db4183109d5b734ec5930d870cdae161e408ddba"
  license "Apache-2.0"
  head "https://github.com/apache/parquet-mr.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "83032114cbf3211065d1b6c6eed1c5cc015537de97dda4cccf8b1b2d6ea29730"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7291370a53a441f2146970ad2aae9702f6d4c30877cab6383405472b200c19b0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ba13e5f576a996077f1d6991a0beec921ba2712d7a0a3ba245f55bff2c7fe650"
    sha256 cellar: :any_skip_relocation, ventura:        "5858da332424e0fc36e4be38b97ee56f40f19b6567d031faf4f82ee8dff2be2b"
    sha256 cellar: :any_skip_relocation, monterey:       "07699736b31de33a4f3714e9699e410a50d70bf4e1e7393d08f67db722140207"
    sha256 cellar: :any_skip_relocation, big_sur:        "c5c1dad7c8bdd4236690462194aae87fe907cfefda954a5881282861c6f7a9f9"
  end

  depends_on "maven" => :build

  # parquet-cli has problems running on Linux, for more information:
  # https://github.com/Homebrew/homebrew-core/pull/94318#issuecomment-1049229342
  depends_on :macos

  depends_on "openjdk"

  # This file generated with `red-parquet` gem:
  #   Arrow::Table.new("values" => ["foo", "Homebrew", "bar"]).save("homebrew.parquet")
  resource("homebrew-test-parquet") do
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
    resource("homebrew-test-parquet").stage testpath

    output = shell_output("#{bin}/parquet cat #{testpath}/homebrew.parquet")
    assert_match "{\"values\": \"Homebrew\"}", output
  end
end
