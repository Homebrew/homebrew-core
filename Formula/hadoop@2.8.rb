class HadoopAT28 < Formula
  desc "Framework for distributed processing of large data sets"
  homepage "https://hadoop.apache.org/"
  url "https://www.apache.org/dyn/closer.cgi?path=hadoop/common/hadoop-2.8.5/hadoop-2.8.5.tar.gz"
  sha256 "f9c726df693ce2daa4107886f603270d66e7257f77a92c9886502d6cd4a884a4"

  bottle :unneeded

  keg_only :versioned_formula

  depends_on :java => "1.8+"

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
