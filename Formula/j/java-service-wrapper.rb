class JavaServiceWrapper < Formula
  desc "Simplify the deployment, launch and monitoring of Java applications"
  homepage "https://wrapper.tanukisoftware.com/"
  url "https://downloads.sourceforge.net/project/wrapper/wrapper_src/Wrapper_3.5.56_20240227/wrapper_3.5.56_src.tar.gz"
  sha256 "cd97c93ffb9fefc0ffe86e752a6d5b351448bf98bcc7af57c3e8a6868e3f6694"
  license any_of: ["GPL-2.0-only", "GPL-3.0-only"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1df31f5f1a68addb3d009ff0f9afbc17798d748474973c4e1786074abc2dcc49"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3808f11ef9a0f386b89ecce7b65e3b7d7a07cd5e7ba9839906655d794d5a654d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "247f5f7cbd4bb61adb1e1f754a4ec747ff27da7995fab4a38ed526f8a611602a"
    sha256 cellar: :any_skip_relocation, sonoma:         "87ab08365cba593e1b6652c83214ec5c1391aa19dd04fe519d38feb407e872cf"
    sha256 cellar: :any_skip_relocation, ventura:        "feb1f2a52fa93da6c62da4ce4c8c9a2cc5a7586bd6488af6451989fb97fb8352"
    sha256 cellar: :any_skip_relocation, monterey:       "dfb8ff6d2a1252d1c1fd92873ef6dc5a81e393b5fcc3026f2015395ae7505004"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a2e4e6cd48b53fe31e28a4def5644daebc42b37d3922dd92713e20835786ebf6"
  end

  depends_on "ant" => :build
  depends_on "openjdk@11" => :build
  on_linux do
    depends_on "cunit" => :build
  end

  def install
    ENV["JAVA_HOME"] = Formula["openjdk@11"].opt_prefix
    # Default javac target version is 1.4, use 1.6 which is the minimum available on openjdk@11
    system "ant", "-Dbits=64", "-Djavac.target.version=1.6"
    libexec.install "lib", "bin", "src/bin" => "scripts"
    if OS.mac?
      if Hardware::CPU.arm?
        ln_s "libwrapper.dylib", libexec/"lib/libwrapper.jnilib"
      else
        ln_s "libwrapper.jnilib", libexec/"lib/libwrapper.dylib"
      end
    end
  end

  test do
    ENV["JAVA_HOME"] = Formula["openjdk@11"].opt_prefix
    output = shell_output("#{libexec}/bin/testwrapper status", 1)
    assert_match("Test Wrapper Sample Application", output)
  end
end
