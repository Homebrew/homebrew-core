class ApacheArchiva < Formula
  desc "Build Artifact Repository Manager"
  homepage "https://archiva.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=archiva/2.2.5/binaries/apache-archiva-2.2.5-bin.tar.gz"
  mirror "https://archive.apache.org/dist/archiva/2.2.5/binaries/apache-archiva-2.2.5-bin.tar.gz"
  sha256 "01119af2d9950eacbcce0b7f8db5067b166ad26c1e1701bef829105441bb6e29"
  license all_of: ["Apache-2.0", "GPL-2.0-only"]
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, all: "7be56a181bec0957d8f4f2936e99a98f737b3f7e146a3f7384b13d9e824919ad"
  end

  depends_on "ant" => :build
  depends_on "openjdk@8" => :build
  depends_on arch: :x86_64 # openjdk@8 doesn't support ARM
  depends_on "openjdk"

  on_linux do
    depends_on "cunit" => :build
  end

  resource "wrapper" do
    url "https://downloads.sourceforge.net/project/wrapper/wrapper_src/Wrapper_3.5.46_20210903/wrapper_3.5.46_src.tar.gz"
    sha256 "82e1d0c85488d1389d02e3abe3359a7f759119e356e3e3abd6c6d67615ae5ad8"
  end

  def install
    libexec.install Dir["*"]
    rm_f Dir["#{libexec}/bin/wrapper*"]
    rm_f Dir["#{libexec}/lib/libwrapper*"]
    (bin/"archiva").write_env_script libexec/"bin/archiva", JAVA_HOME: Formula["openjdk"].opt_prefix

    resource("wrapper").stage do
      # Use openjdk@8, fixes: error: Target option 1.4 is no longer supported. Use 7 or later.
      ENV["JAVA_HOME"] = Formula["openjdk@8"].opt_prefix
      ENV["ANT_HOME"] = Formula["ant"].opt_libexec
      system "./build64.sh"
      libexec.install "bin/wrapper" => "#{libexec}/bin/wrapper"
      libext = OS.mac? ? "jnilib" : "so"
      libexec.install "lib/libwrapper.#{libext}" => "#{libexec}/lib/libwrapper.#{libext}"
      libexec.install "lib/wrapper.jar" => "#{libexec}/lib/wrapper.jar"
    end
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
