class Metabase < Formula
  desc "Business intelligence report server"
  homepage "https://www.metabase.com/"
  url "https://downloads.metabase.com/v0.63.14/metabase.jar"
  sha256 "2e0c6d64db01b9fdae2243d42222fbd30b43209fc3ddc5927c61d26f8f476a02"
  license "AGPL-3.0-only"

  # The first-party download page only provides an unversioned link to the
  # latest OSS jar file. We check the "latest" GitHub release, as the release
  # body text contains a versioned link to the OSS jar file.
  livecheck do
    url "https://github.com/metabase/metabase.git"
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "cd4c10016335788b84b451fd1f4c89987827d2ca3065061a5761536b4c94df0e"
  end

  depends_on "openjdk"

  def install
    libexec.install "metabase.jar"
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
