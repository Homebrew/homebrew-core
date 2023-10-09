class Metabase < Formula
  desc "Business intelligence report server"
  homepage "https://www.metabase.com/"
  url "https://downloads.metabase.com/v0.47.3/metabase.jar"
  sha256 "a08188ac46b6887befb1e3f7b007308942bb932e37b1c7f26923bb4b71bb6c4a"
  license "AGPL-3.0-only"

  livecheck do
    url "https://www.metabase.com/start/oss/jar.html"
    regex(%r{href=.*?/v?(\d+(?:\.\d+)+)/metabase\.jar}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8b49a3a7c39483a29e5ab7cfcfc2ccf7835d26f158a4b704d138b980795e4a48"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8b49a3a7c39483a29e5ab7cfcfc2ccf7835d26f158a4b704d138b980795e4a48"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8b49a3a7c39483a29e5ab7cfcfc2ccf7835d26f158a4b704d138b980795e4a48"
    sha256 cellar: :any_skip_relocation, sonoma:         "8b49a3a7c39483a29e5ab7cfcfc2ccf7835d26f158a4b704d138b980795e4a48"
    sha256 cellar: :any_skip_relocation, ventura:        "8b49a3a7c39483a29e5ab7cfcfc2ccf7835d26f158a4b704d138b980795e4a48"
    sha256 cellar: :any_skip_relocation, monterey:       "8b49a3a7c39483a29e5ab7cfcfc2ccf7835d26f158a4b704d138b980795e4a48"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "da327cf737d35decb6c689547881a8b0552d465eec11db0339b358b1723faa09"
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
