class JavaServiceWrapper < Formula
  desc "Simplify the deployment, launch and monitoring of Java applications"
  homepage "https://wrapper.tanukisoftware.com/"
  url "https://downloads.sourceforge.net/project/wrapper/wrapper_src/Wrapper_3.5.46_20210903/wrapper_3.5.46_src.tar.gz"
  sha256 "82e1d0c85488d1389d02e3abe3359a7f759119e356e3e3abd6c6d67615ae5ad8"
  license "GPL-2.0-only"

  depends_on "openjdk@11" => :build

  def install
    ENV["JAVA_HOME"] = Formula["openjdk@11"].opt_prefix
    system "ant", "-Dbits=64", "-Djavac.target.version=1.6"
    libexec.install "lib", "bin", "src/bin" => "scripts"
  end

  test do
    shell_output("#{libexec}/bin/testwrapper status", 1)
  end
end
