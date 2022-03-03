class Hadoop < Formula
  desc "Framework for distributed processing of large data sets"
  homepage "https://hadoop.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=hadoop/common/hadoop-3.3.2/hadoop-3.3.2.tar.gz"
  mirror "https://archive.apache.org/dist/hadoop/common/hadoop-3.3.2/hadoop-3.3.2.tar.gz"
  sha256 "b341587495b12eec0b244b517f21df88eb46ef634dc7dc3e5969455b80ce2ce5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9137835a8e895a63beeb16e429b52d9578973b20de89c8ea5bf3b327c4070229"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9137835a8e895a63beeb16e429b52d9578973b20de89c8ea5bf3b327c4070229"
    sha256 cellar: :any_skip_relocation, monterey:       "b7a267d1262025ee2ba27a3f7b3262e742728226834f9224e7cf64f5bef8a2c4"
    sha256 cellar: :any_skip_relocation, big_sur:        "b7a267d1262025ee2ba27a3f7b3262e742728226834f9224e7cf64f5bef8a2c4"
    sha256 cellar: :any_skip_relocation, catalina:       "b7a267d1262025ee2ba27a3f7b3262e742728226834f9224e7cf64f5bef8a2c4"
    sha256 cellar: :any_skip_relocation, mojave:         "b7a267d1262025ee2ba27a3f7b3262e742728226834f9224e7cf64f5bef8a2c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6ab7ec87e14d03ddfae37c0c2ab5526570dfcd35a27dd253b70d27a1109bf3f8"
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
