class Metabase < Formula
  desc "Business intelligence report server"
  homepage "https://www.metabase.com/"
  url "https://downloads.metabase.com/v0.47.4/metabase.jar"
  sha256 "e687fdaabf06e23ed1f4bf6e40173834d2fc9b2b306796ab67b1d7603f483fd2"
  license "AGPL-3.0-only"

  livecheck do
    url "https://www.metabase.com/start/oss/jar.html"
    regex(%r{href=.*?/v?(\d+(?:\.\d+)+)/metabase\.jar}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "85adaf7b08c4a9660b20c1d02fe6bb7ee9477dfc9aefedf253bf7ede6c8ba3ef"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "85adaf7b08c4a9660b20c1d02fe6bb7ee9477dfc9aefedf253bf7ede6c8ba3ef"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "85adaf7b08c4a9660b20c1d02fe6bb7ee9477dfc9aefedf253bf7ede6c8ba3ef"
    sha256 cellar: :any_skip_relocation, sonoma:         "85adaf7b08c4a9660b20c1d02fe6bb7ee9477dfc9aefedf253bf7ede6c8ba3ef"
    sha256 cellar: :any_skip_relocation, ventura:        "85adaf7b08c4a9660b20c1d02fe6bb7ee9477dfc9aefedf253bf7ede6c8ba3ef"
    sha256 cellar: :any_skip_relocation, monterey:       "85adaf7b08c4a9660b20c1d02fe6bb7ee9477dfc9aefedf253bf7ede6c8ba3ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "13967eeeeaf6d5ff1b01064e3ee7d99d87addbd8adbd4e90960c90a1e0de5a56"
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
