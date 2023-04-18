class ParquetCli < Formula
  desc "Apache Parquet command-line tools and utilities"
  homepage "https://parquet.apache.org/"
  url "https://github.com/apache/parquet-mr.git",
      tag:      "apache-parquet-1.13.0",
      revision: "2e369ed173f66f057c296e63c1bc31d77f294f41"
  license "Apache-2.0"
  head "https://github.com/apache/parquet-mr.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1840b21ce2dbdd52dca94676ed160c16eb55c5e9891697fca4ce885c665ba9ae"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0c6d36813908a919c7528e6e7ef4e1719e776effac3246d3061ef7a743b973b2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f544b6bcd97ad4cc4febaf39d8c0010c893c6358f03585888cd262cf2922eab4"
    sha256 cellar: :any_skip_relocation, ventura:        "690e74de2b5c729d6cd4ab76f05c998eaba386c05412a28ef6d2cb397a6af343"
    sha256 cellar: :any_skip_relocation, monterey:       "f200d41d0436d462894d6071d3b5c96fc60b9767192f3dbea706c043d5e2ed36"
    sha256 cellar: :any_skip_relocation, big_sur:        "e15ad9d382aa3b558577835c569852b13316e7ab2df9755f0b8a2c25cbcd0d70"
  end

  depends_on "maven" => :build

  # parquet-cli has problems running on Linux, for more information:
  # https://github.com/Homebrew/homebrew-core/pull/94318#issuecomment-1049229342
  depends_on :macos

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
