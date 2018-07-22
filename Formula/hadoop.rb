class Hadoop < Formula
  desc "Framework for distributed processing of large data sets"
  homepage "https://hadoop.apache.org/"
  url "https://www.apache.org/dyn/closer.cgi?path=hadoop/common/hadoop-3.1.0/hadoop-3.1.0.tar.gz"
  sha256 "670d2ced595fa42d9fa1a93c4e39b39f47002cad1553d9df163ee828ca5143e7"

  bottle :unneeded

  depends_on :java => "1.8+"

  conflicts_with "yarn", :because => "both install `yarn` binaries"

  def install
    rm_f Dir["bin/*.cmd", "sbin/*.cmd", "libexec/*.cmd", "etc/hadoop/*.cmd"]
    libexec.install %w[bin sbin libexec share etc]
    bin.write_exec_script Dir["#{libexec}/bin/*"]
    sbin.write_exec_script Dir["#{libexec}/sbin/*"]
  end

  test do
    system bin/"hadoop", "fs", "-ls"
  end
end
