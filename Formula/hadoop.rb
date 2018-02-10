class Hadoop < Formula
  desc "Framework for distributed processing of large data sets"
  homepage "https://hadoop.apache.org/"
  url "https://www.apache.org/dyn/closer.cgi?path=hadoop/common/hadoop-3.0.0/hadoop-3.0.0.tar.gz"
  mirror "https://archive.apache.org/dist/hadoop/common/hadoop-3.0.0/hadoop-3.0.0.tar.gz"
  sha256 "726e28fa7aea71e4587ce91ed3d96c56b15777fc859c09a7438a6d0092e08c74"

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
