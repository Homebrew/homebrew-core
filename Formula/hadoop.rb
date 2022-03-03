class Hadoop < Formula
  desc "Framework for distributed processing of large data sets"
  homepage "https://hadoop.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=hadoop/common/hadoop-3.3.2/hadoop-3.3.2.tar.gz"
  mirror "https://archive.apache.org/dist/hadoop/common/hadoop-3.3.2/hadoop-3.3.2.tar.gz"
  sha256 "b341587495b12eec0b244b517f21df88eb46ef634dc7dc3e5969455b80ce2ce5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bfd994bb95f34c6321a9bcff2fda04c3a71684675420f0b185099393d830b3e9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bfd994bb95f34c6321a9bcff2fda04c3a71684675420f0b185099393d830b3e9"
    sha256 cellar: :any_skip_relocation, monterey:       "ff9fc2728e7cf70c56c4dab0423c5d666e3d08ba32d336a7f8ea911f8c57f24d"
    sha256 cellar: :any_skip_relocation, big_sur:        "ff9fc2728e7cf70c56c4dab0423c5d666e3d08ba32d336a7f8ea911f8c57f24d"
    sha256 cellar: :any_skip_relocation, catalina:       "ff9fc2728e7cf70c56c4dab0423c5d666e3d08ba32d336a7f8ea911f8c57f24d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9e80b0972bb123a83d2076efc902ff2acbfcf64406708453802aee24efbb9e23"
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
