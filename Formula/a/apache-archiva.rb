class ApacheArchiva < Formula
  desc "Build Artifact Repository Manager"
  homepage "https://archiva.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=archiva/2.2.10/binaries/apache-archiva-2.2.10-bin.tar.gz"
  mirror "https://archive.apache.org/dist/archiva/2.2.10/binaries/apache-archiva-2.2.10-bin.tar.gz"
  sha256 "9d468f5cd3d7f6841e133e853fc24e73fb62397091f1bb3601b6f157a5eadf77"
  license all_of: ["Apache-2.0", "GPL-2.0-only"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "0353821ce360af9daa593f637080c56b6e2cfbdd79430d90592577476aefd5be"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "608f320fba80feaae78ae4a9245939f3c115a06ad852b83a510332f816982fc3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d50d77e7248f8d9c91d0db6952a249cd7913d9463268e99494d909defc5d3a24"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d50d77e7248f8d9c91d0db6952a249cd7913d9463268e99494d909defc5d3a24"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d50d77e7248f8d9c91d0db6952a249cd7913d9463268e99494d909defc5d3a24"
    sha256 cellar: :any_skip_relocation, sonoma:         "608f320fba80feaae78ae4a9245939f3c115a06ad852b83a510332f816982fc3"
    sha256 cellar: :any_skip_relocation, ventura:        "d50d77e7248f8d9c91d0db6952a249cd7913d9463268e99494d909defc5d3a24"
    sha256 cellar: :any_skip_relocation, monterey:       "d50d77e7248f8d9c91d0db6952a249cd7913d9463268e99494d909defc5d3a24"
    sha256 cellar: :any_skip_relocation, big_sur:        "d50d77e7248f8d9c91d0db6952a249cd7913d9463268e99494d909defc5d3a24"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "e1c07d5cd8ea4779a08546249c6599e57e1838c1613b7607f1dfbc1b9207f90e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b8e45fbe48a08a1244ea72537e4eb0d550cd73f7977250a6b1b9d31bcd2a5b90"
  end

  deprecate! date: "2024-05-01", because: :repo_archived
  disable! date: "2025-05-05", because: :repo_archived

  depends_on "ant" => :build
  depends_on "java-service-wrapper"
  depends_on "openjdk"

  def install
    libexec.install Dir["*"]
    rm(libexec.glob("bin/wrapper*"))
    rm(libexec.glob("lib/libwrapper*"))
    (bin/"archiva").write_env_script libexec/"bin/archiva", Language::Java.java_home_env

    wrapper = Formula["java-service-wrapper"].opt_libexec
    ln_sf wrapper/"bin/wrapper", libexec/"bin/wrapper"
    libext = OS.mac? ? "jnilib" : "so"
    ln_sf wrapper/"lib/libwrapper.#{libext}", libexec/"lib/libwrapper.#{libext}"
    ln_sf wrapper/"lib/wrapper.jar", libexec/"lib/wrapper.jar"
  end

  def post_install
    (var/"archiva/logs").mkpath
    (var/"archiva/data").mkpath
    (var/"archiva/temp").mkpath

    cp_r libexec/"conf", var/"archiva"
  end

  service do
    run [opt_bin/"archiva", "console"]
    environment_variables ARCHIVA_BASE: var/"archiva"
    log_path var/"archiva/logs/launchd.log"
  end

  test do
    assert_match "was not running.", shell_output("#{bin}/archiva stop")
  end
end
