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
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "45197338beccbff397539fd890c7ec3e529e148a5f9cb4953a765afc39e6597f"
    sha256 cellar: :any_skip_relocation, big_sur:       "45197338beccbff397539fd890c7ec3e529e148a5f9cb4953a765afc39e6597f"
    sha256 cellar: :any_skip_relocation, catalina:      "45197338beccbff397539fd890c7ec3e529e148a5f9cb4953a765afc39e6597f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "665e514817999a9ae5adea22bd8689c0f87c908478d5274176f71bc07cc74f87"
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
