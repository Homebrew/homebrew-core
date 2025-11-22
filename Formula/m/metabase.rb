class Metabase < Formula
  desc "Business intelligence report server"
  homepage "https://www.metabase.com/"
  url "https://downloads.metabase.com/v0.57.3/metabase.jar"
  sha256 "ebf4637a6fcdd9e75460566916ea8b7a11f59357ab5a0b2850f8b4bfc183a359"
  license "AGPL-3.0-only"

  # The first-party download page only provides an unversioned link to the
  # latest OSS jar file. We check the "latest" GitHub release, as the release
  # body text contains a versioned link to the OSS jar file.
  livecheck do
    url :head
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "1dfcb56c15b976b390202dc25b073042578ad15fc8a5c67117144d4a1642665a"
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
    error_log_path File::NULL
  end

  test do
    system bin/"metabase", "migrate", "up"
  end
end
