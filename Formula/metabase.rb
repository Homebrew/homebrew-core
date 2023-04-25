class Metabase < Formula
  desc "Business intelligence report server"
  homepage "https://www.metabase.com/"
  url "https://downloads.metabase.com/v0.46.1/metabase.jar"
  sha256 "e21897cddf1864989ec06d2fa21e3faf26f73700472abc3794aa543c0e6709dc"
  license "AGPL-3.0-only"

  livecheck do
    url "https://www.metabase.com/start/oss/jar.html"
    regex(%r{href=.*?/v?(\d+(?:\.\d+)+)/metabase\.jar}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9e6e5f405716173c950abe7bd5d779238e71519f142a28a57c7d1d941ac60baa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9e6e5f405716173c950abe7bd5d779238e71519f142a28a57c7d1d941ac60baa"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9e6e5f405716173c950abe7bd5d779238e71519f142a28a57c7d1d941ac60baa"
    sha256 cellar: :any_skip_relocation, ventura:        "9e6e5f405716173c950abe7bd5d779238e71519f142a28a57c7d1d941ac60baa"
    sha256 cellar: :any_skip_relocation, monterey:       "9e6e5f405716173c950abe7bd5d779238e71519f142a28a57c7d1d941ac60baa"
    sha256 cellar: :any_skip_relocation, big_sur:        "9e6e5f405716173c950abe7bd5d779238e71519f142a28a57c7d1d941ac60baa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cf71f961eebc1dd48619878a62ae6591eb0fd91096601c5d1e657a2a90c707ed"
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
