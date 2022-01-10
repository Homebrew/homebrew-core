class Pinotbase < Formula
  desc "Base file dependencies for Apache Pinot components"
  homepage "https://pinot.apache.org/"
  url "https://downloads.apache.org/pinot/apache-pinot-0.9.3/apache-pinot-0.9.3-bin.tar.gz"
  sha256 "c253eb9ce93f11f368498229282846588f478cb6e0359e24167b13e97417c025"
  license "Apache-2.0"
  revision 1
  head "https://github.com/apache/pinot.git", branch: "master"

  depends_on "libtool" => :build

  def install
    libexec.install "lib"
    libexec.install "plugins"

    prefix.install "bin"
    bin.env_script_all_files(libexec/"bin", Language::Java.java_home_env)
    Dir["#{bin}/*.sh"].each { |f| mv f, f.to_s.gsub(/.sh$/, "") }
  end

  test do
    assert_match(/Usage: pinot-admin.sh <subCommand>/, shell_output("#{bin}/pinot-admin -h 2>&1"))
  end
end
