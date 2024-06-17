class Metabase < Formula
  desc "Business intelligence report server"
  homepage "https://www.metabase.com/"
  url "https://downloads.metabase.com/v0.50.4/metabase.jar"
  sha256 "8ec74901daf6324d515ddcc35e572ffe909bedf604661b149b7f7eae07d541ce"
  license "AGPL-3.0-only"

  livecheck do
    url "https://www.metabase.com/start/oss/jar.html"
    regex(%r{href=.*?/v?(\d+(?:\.\d+)+)/metabase\.jar}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9c43d4e25be05db04b2e8a1d40c7a4f720780a2e38ec675ad4dcd887951e1206"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9c43d4e25be05db04b2e8a1d40c7a4f720780a2e38ec675ad4dcd887951e1206"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9c43d4e25be05db04b2e8a1d40c7a4f720780a2e38ec675ad4dcd887951e1206"
    sha256 cellar: :any_skip_relocation, sonoma:         "9c43d4e25be05db04b2e8a1d40c7a4f720780a2e38ec675ad4dcd887951e1206"
    sha256 cellar: :any_skip_relocation, ventura:        "9c43d4e25be05db04b2e8a1d40c7a4f720780a2e38ec675ad4dcd887951e1206"
    sha256 cellar: :any_skip_relocation, monterey:       "9c43d4e25be05db04b2e8a1d40c7a4f720780a2e38ec675ad4dcd887951e1206"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b9d2935e946502ef1c329d6d1d23c94eb3a6081e1deed1279c4019c6900f583d"
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
