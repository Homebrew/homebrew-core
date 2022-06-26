class Hadoop < Formula
  desc "Framework for distributed processing of large data sets"
  homepage "https://hadoop.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=hadoop/common/hadoop-3.3.3/hadoop-3.3.3.tar.gz"
  mirror "https://archive.apache.org/dist/hadoop/common/hadoop-3.3.3/hadoop-3.3.3.tar.gz"
  sha256 "fa71c61bbaa427129aef09fec028b34dd542c65ad90fdccec5e7ef93d83b8764"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "94c5dc702bb5334513b38358a46cf1eb439feabac4f59f5e38056bd5353f841e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "94c5dc702bb5334513b38358a46cf1eb439feabac4f59f5e38056bd5353f841e"
    sha256 cellar: :any_skip_relocation, monterey:       "ce602f144779cd6e81bb97fd8b07a835f925dff80d6ad49a123cae1c251a1782"
    sha256 cellar: :any_skip_relocation, big_sur:        "ce602f144779cd6e81bb97fd8b07a835f925dff80d6ad49a123cae1c251a1782"
    sha256 cellar: :any_skip_relocation, catalina:       "ce602f144779cd6e81bb97fd8b07a835f925dff80d6ad49a123cae1c251a1782"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4c572401d48a3985d201af646cb670c7fb6806e95d9d0664cf3de9472bd2eb8d"
  end

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
