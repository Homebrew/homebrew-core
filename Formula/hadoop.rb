class Hadoop < Formula
  desc "Framework for distributed processing of large data sets"
  homepage "https://hadoop.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=hadoop/common/hadoop-3.3.0/hadoop-3.3.0.tar.gz"
  mirror "https://archive.apache.org/dist/hadoop/common/hadoop-3.3.0/hadoop-3.3.0.tar.gz"
  sha256 "ea1a0f0afcdfb9b6b9d261cdce5a99023d7e8f72d26409e87f69bda65c663688"
  license "Apache-2.0"

  bottle :unneeded

  depends_on "openjdk"

  conflicts_with "yarn", because: "both install `yarn` binaries"

  def install
    rm_f Dir["bin/*.cmd", "sbin/*.cmd", "libexec/*.cmd", "etc/hadoop/*.cmd"]
    libexec.install %w[bin sbin libexec share etc]
    Dir["#{libexec}/bin/*"].each do |path|
      (bin/File.basename(path)).write_env_script path, JAVA_HOME: Formula["openjdk"].opt_prefix
    end
    Dir["#{libexec}/sbin/*"].each do |path|
      (sbin/File.basename(path)).write_env_script path, JAVA_HOME: Formula["openjdk"].opt_prefix
    end
    Dir["#{libexec}/libexec/*.sh"].each do |path|
      (libexec/File.basename(path)).write_env_script path, JAVA_HOME: Formula["openjdk"].opt_prefix
    end
    # Temporary fix until https://github.com/Homebrew/brew/pull/4512 is fixed
    chmod 0755, Dir["#{libexec}/*.sh"]
  end

  test do
    system bin/"hadoop", "fs", "-ls"
  end
end
