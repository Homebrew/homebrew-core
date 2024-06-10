class Metabase < Formula
  desc "Business intelligence report server"
  homepage "https://www.metabase.com/"
  url "https://downloads.metabase.com/v0.49.14/metabase.jar"
  sha256 "77a08d7710d79f82c52c1d1e3cd3d4edc10bd8406d93eec9988d12158334ecc3"
  license "AGPL-3.0-only"

  livecheck do
    url "https://www.metabase.com/start/oss/jar.html"
    regex(%r{href=.*?/v?(\d+(?:\.\d+)+)/metabase\.jar}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ec94848cb401f0554a74cae3231e503614b3fddbd594c7f2f555ddae2912fabb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ec94848cb401f0554a74cae3231e503614b3fddbd594c7f2f555ddae2912fabb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ec94848cb401f0554a74cae3231e503614b3fddbd594c7f2f555ddae2912fabb"
    sha256 cellar: :any_skip_relocation, sonoma:         "ec94848cb401f0554a74cae3231e503614b3fddbd594c7f2f555ddae2912fabb"
    sha256 cellar: :any_skip_relocation, ventura:        "ec94848cb401f0554a74cae3231e503614b3fddbd594c7f2f555ddae2912fabb"
    sha256 cellar: :any_skip_relocation, monterey:       "ec94848cb401f0554a74cae3231e503614b3fddbd594c7f2f555ddae2912fabb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "57e9c8d96d6c20a4f6597687c59b3ffae4dc59f085fb89c9c321a4f8de99ac1c"
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
