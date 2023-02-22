class Metabase < Formula
  desc "Business intelligence report server"
  homepage "https://www.metabase.com/"
  url "https://downloads.metabase.com/v0.45.3/metabase.jar"
  sha256 "b7eedcba1bf1bf8843f66608aa976ec206353fb13ad8acb10471f9fe35d56968"
  license "AGPL-3.0-only"

  livecheck do
    url "https://www.metabase.com/start/oss/jar.html"
    regex(%r{href=.*?/v?(\d+(?:\.\d+)+)/metabase\.jar}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fb9ff970173bfb4c5345a0088585950ac391d4d352cb9f5a12975b44b298bcba"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fb9ff970173bfb4c5345a0088585950ac391d4d352cb9f5a12975b44b298bcba"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fb9ff970173bfb4c5345a0088585950ac391d4d352cb9f5a12975b44b298bcba"
    sha256 cellar: :any_skip_relocation, ventura:        "fb9ff970173bfb4c5345a0088585950ac391d4d352cb9f5a12975b44b298bcba"
    sha256 cellar: :any_skip_relocation, monterey:       "fb9ff970173bfb4c5345a0088585950ac391d4d352cb9f5a12975b44b298bcba"
    sha256 cellar: :any_skip_relocation, big_sur:        "fb9ff970173bfb4c5345a0088585950ac391d4d352cb9f5a12975b44b298bcba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "61b18479da9f842131c7da7f6cc51a06eb5a06a8010383b386d18203ea0e2d75"
  end

  head do
    url "https://github.com/metabase/metabase.git", branch: "master"

    depends_on "leiningen" => :build
    depends_on "node" => :build
    depends_on "yarn" => :build
  end

  depends_on "openjdk"

  def install
    if build.head?
      system "./bin/build"
      libexec.install "target/uberjar/metabase.jar"
    else
      libexec.install "metabase.jar"
    end

    bin.write_jar_script libexec/"metabase.jar", "metabase"
  end

  service do
    run opt_bin/"metabase"
    keep_alive true
    require_root true
    working_dir var/"metabase"
    log_path var/"metabase/server.log"
    error_log_path "/dev/null"
  end

  test do
    system bin/"metabase", "migrate", "up"
  end
end
