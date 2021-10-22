class Metabase < Formula
  desc "Business intelligence report server"
  homepage "https://www.metabase.com/"
  url "https://downloads.metabase.com/v0.41.1/metabase.jar"
  sha256 "8a222bf5b255dc80eb783a85b003b44835e24b739ae9e110e1ba0f583d86fd42"
  license "AGPL-3.0-only"

  livecheck do
    url "https://www.metabase.com/start/oss/jar.html"
    regex(%r{href=.*?/v?(\d+(?:\.\d+)+)/metabase\.jar}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "6906a309c8953833b66c1989fe727453283f04087469d721dc25c3e1f8fac0d1"
  end

  head do
    url "https://github.com/metabase/metabase.git"

    depends_on "leiningen" => :build
    depends_on "node" => :build
    depends_on "yarn" => :build
  end

  # metabase uses jdk.nashorn.api.scripting.JSObject
  # which is removed in Java 15
  depends_on "openjdk@11"

  def install
    if build.head?
      system "./bin/build"
      libexec.install "target/uberjar/metabase.jar"
    else
      libexec.install "metabase.jar"
    end

    bin.write_jar_script libexec/"metabase.jar", "metabase", java_version: "11"
  end

  plist_options startup: true
  service do
    run opt_bin/"metabase"
    keep_alive true
    working_dir var/"metabase"
    log_path var/"metabase/server.log"
    error_log_path "/dev/null"
  end

  test do
    system bin/"metabase", "migrate", "up"
  end
end
