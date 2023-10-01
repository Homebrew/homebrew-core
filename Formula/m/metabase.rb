class Metabase < Formula
  desc "Business intelligence report server"
  homepage "https://www.metabase.com/"
  url "https://downloads.metabase.com/v0.47.2/metabase.jar"
  sha256 "94f7335561881f6da4f4cea54683e477e9da91eeade99f97bce020281a23076c"
  license "AGPL-3.0-only"

  livecheck do
    url "https://www.metabase.com/start/oss/jar.html"
    regex(%r{href=.*?/v?(\d+(?:\.\d+)+)/metabase\.jar}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9ce04ebc6493e6be13ad9e2a7440d3e7329bf96d7093ae26e546f3cb27c2c198"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9ce04ebc6493e6be13ad9e2a7440d3e7329bf96d7093ae26e546f3cb27c2c198"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9ce04ebc6493e6be13ad9e2a7440d3e7329bf96d7093ae26e546f3cb27c2c198"
    sha256 cellar: :any_skip_relocation, ventura:        "9ce04ebc6493e6be13ad9e2a7440d3e7329bf96d7093ae26e546f3cb27c2c198"
    sha256 cellar: :any_skip_relocation, monterey:       "9ce04ebc6493e6be13ad9e2a7440d3e7329bf96d7093ae26e546f3cb27c2c198"
    sha256 cellar: :any_skip_relocation, big_sur:        "9ce04ebc6493e6be13ad9e2a7440d3e7329bf96d7093ae26e546f3cb27c2c198"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8baf06f41e7d0971c3ab469630f59507dfa8dcdafa116d94ad1f09ee71a2606f"
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
