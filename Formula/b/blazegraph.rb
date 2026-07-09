class Blazegraph < Formula
  desc "Graph database supporting RDF data model, Sesame, and Blueprint APIs"
  homepage "https://blazegraph.com/"
  url "https://github.com/blazegraph/database/releases/download/BLAZEGRAPH_RELEASE_2_1_5/blazegraph.jar"
  version "2.1.5"
  sha256 "fbaeae7e1b3af71f57cfc4da58b9c52a9ae40502d431c76bafa5d5570d737610"
  license "GPL-2.0-only"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "3f006e1ce3a63d62b14b3274a11417ac02fa7585e5036bcba32fe4264deda8e3"
  end

  # see https://github.com/blazegraph/database/issues/196
  # 2.1.6 release in rc phase for four years
  deprecate! date: "2024-07-26", because: :unmaintained
  disable! date: "2025-07-26", because: :unmaintained

  # Dependencies can be lifted in the upcoming release, > 2.1.5
  depends_on "openjdk@8"

  def install
    libexec.install "blazegraph.jar"
    bin.write_jar_script libexec/"blazegraph.jar", "blazegraph", java_version: "1.8"
  end

  service do
    run opt_bin/"blazegraph"
    require_root true
    working_dir opt_prefix
  end

  test do
    ENV.prepend "_JAVA_OPTIONS", "-Djava.io.tmpdir=#{testpath}"

    server = fork do
      exec bin/"blazegraph"
    end
    sleep 5
    Process.kill("TERM", server)
    assert_path_exists testpath/"blazegraph.jnl"
    assert_path_exists testpath/"rules.log"
  end
end
