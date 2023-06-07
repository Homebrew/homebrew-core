class Metabase < Formula
  desc "Business intelligence report server"
  homepage "https://www.metabase.com/"
  url "https://downloads.metabase.com/v0.46.4/metabase.jar"
  sha256 "b16997d64e7cd6decec23b7692c134c67a34abcb035bd5a048b9a38da75fe506"
  license "AGPL-3.0-only"

  livecheck do
    url "https://www.metabase.com/start/oss/jar.html"
    regex(%r{href=.*?/v?(\d+(?:\.\d+)+)/metabase\.jar}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f35ecc3f118e1edfbed17a9720819f8822252d52d727fbd445bdeecf77b9bbe5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f35ecc3f118e1edfbed17a9720819f8822252d52d727fbd445bdeecf77b9bbe5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f35ecc3f118e1edfbed17a9720819f8822252d52d727fbd445bdeecf77b9bbe5"
    sha256 cellar: :any_skip_relocation, ventura:        "f35ecc3f118e1edfbed17a9720819f8822252d52d727fbd445bdeecf77b9bbe5"
    sha256 cellar: :any_skip_relocation, monterey:       "f35ecc3f118e1edfbed17a9720819f8822252d52d727fbd445bdeecf77b9bbe5"
    sha256 cellar: :any_skip_relocation, big_sur:        "f35ecc3f118e1edfbed17a9720819f8822252d52d727fbd445bdeecf77b9bbe5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "59f34c4b298aa6b86e9300832c869846cfd14964d707c0c25fffe5ccf6e08011"
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
