class Hadoop < Formula
  desc "Framework for distributed processing of large data sets"
  homepage "https://hadoop.apache.org/"
  url "https://www.apache.org/dyn/closer.cgi?path=hadoop/common/hadoop-3.1.2/hadoop-3.1.2.tar.gz"
  sha256 "1c02ccc60a09c63a48dc4234ffd3aed1b75e5a1f2b49d60927eda114b93dd31a"

  bottle :unneeded

  depends_on :java => "1.8+"

  conflicts_with "yarn", :because => "both install `yarn` binaries"

  def install
    rm_f Dir["bin/*.cmd", "sbin/*.cmd", "libexec/*.cmd", "etc/hadoop/*.cmd"]
    libexec.install %w[bin sbin libexec share etc]
    bin.write_exec_script Dir["#{libexec}/bin/*"]
    sbin.write_exec_script Dir["#{libexec}/sbin/*"]
    libexec.write_exec_script Dir["#{libexec}/libexec/*.sh"]
    # Temporary fix until https://github.com/Homebrew/brew/pull/4512 is fixed
    chmod 0755, Dir["#{libexec}/*.sh"]
  end

  test do
    system bin/"hadoop", "fs", "-ls"
  end
end
