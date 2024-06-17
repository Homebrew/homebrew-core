class JavaServiceWrapper < Formula
  desc "Simplify the deployment, launch and monitoring of Java applications"
  homepage "https://wrapper.tanukisoftware.com/"
  url "https://downloads.sourceforge.net/project/wrapper/wrapper_src/Wrapper_3.5.57_20240520/wrapper_3.5.57_src.tar.gz"
  sha256 "f3a62eb20c8b52f78cad77a902d9c00607590869500d08d51671bd1aa1670888"
  license any_of: ["GPL-2.0-only", "GPL-3.0-only"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b417c3a55947ff8e3a02f44bc8873e01ac1272f07fb55a9728a37c2eb8263443"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e053670f00879fa2f5d88cca19641839b0b945d2343780132fb00c2bad9a5e8d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6958a108c6106123873688c9859749ed5ac04cb0f47b954a5ca4f5984ac0ace7"
    sha256 cellar: :any_skip_relocation, sonoma:         "7e1750d31b39572e6a30d35965a4be9064af55edd76b2a85c4ef7f1c151f19c7"
    sha256 cellar: :any_skip_relocation, ventura:        "5dc422c28e32881c3cceff9fdad8474a360ebde327f887cc2af5304a546d0e4d"
    sha256 cellar: :any_skip_relocation, monterey:       "22591cc0ed3e3b719cf511ad3293b37f6f9f851a0dce9aa207430fc436028c4f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "32900e8514b516dc6f6b6fb3852b75502a1e230ec993cfeefe0d03f6d6374c23"
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
