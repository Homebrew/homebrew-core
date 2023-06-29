class Metabase < Formula
  desc "Business intelligence report server"
  homepage "https://www.metabase.com/"
  url "https://downloads.metabase.com/v0.46.5/metabase.jar"
  sha256 "e45f01438da1ba7faa524ebf5f57524e58511970443eaf61d087c91c0efb38ec"
  license "AGPL-3.0-only"

  livecheck do
    url "https://www.metabase.com/start/oss/jar.html"
    regex(%r{href=.*?/v?(\d+(?:\.\d+)+)/metabase\.jar}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "926e953bcc670f3e8392f00b3406062930a3ae1d38cf201cf5356d6d74c557bf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "926e953bcc670f3e8392f00b3406062930a3ae1d38cf201cf5356d6d74c557bf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "926e953bcc670f3e8392f00b3406062930a3ae1d38cf201cf5356d6d74c557bf"
    sha256 cellar: :any_skip_relocation, ventura:        "926e953bcc670f3e8392f00b3406062930a3ae1d38cf201cf5356d6d74c557bf"
    sha256 cellar: :any_skip_relocation, monterey:       "926e953bcc670f3e8392f00b3406062930a3ae1d38cf201cf5356d6d74c557bf"
    sha256 cellar: :any_skip_relocation, big_sur:        "926e953bcc670f3e8392f00b3406062930a3ae1d38cf201cf5356d6d74c557bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "61792ee42e5c239c2304854c9295e381a7763f043e5175251445bef988b861cb"
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
