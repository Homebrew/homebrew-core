class Hadoop < Formula
  desc "Framework for distributed processing of large data sets"
  homepage "https://hadoop.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=hadoop/common/hadoop-3.3.4/hadoop-3.3.4.tar.gz"
  mirror "https://archive.apache.org/dist/hadoop/common/hadoop-3.3.4/hadoop-3.3.4.tar.gz"
  sha256 "6a483d1a0b123490ebd8df3f71b64eb39f333f78b95f090aeb58e433cbc2416d"
  license "Apache-2.0"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "caad5e1aa87bf016bdb4bd6e828e21640136ad33d18de09410d2bf4f2e985f00"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "caad5e1aa87bf016bdb4bd6e828e21640136ad33d18de09410d2bf4f2e985f00"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "caad5e1aa87bf016bdb4bd6e828e21640136ad33d18de09410d2bf4f2e985f00"
    sha256 cellar: :any_skip_relocation, ventura:        "a7285cf8aeaae3e175340d73f5458aad739dcf377e5e3c622867f3889a5921da"
    sha256 cellar: :any_skip_relocation, monterey:       "a7285cf8aeaae3e175340d73f5458aad739dcf377e5e3c622867f3889a5921da"
    sha256 cellar: :any_skip_relocation, big_sur:        "a7285cf8aeaae3e175340d73f5458aad739dcf377e5e3c622867f3889a5921da"
    sha256 cellar: :any_skip_relocation, catalina:       "a7285cf8aeaae3e175340d73f5458aad739dcf377e5e3c622867f3889a5921da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c530bd41f56225df151a59de2ad0043c574ff6d9984c4f12e71c90c7644e4de3"
  end

  # WARNING: Check https://cwiki.apache.org/confluence/display/HADOOP/Hadoop+Java+Versions before updating JDK version
  depends_on "openjdk@11"

  conflicts_with "yarn", because: "both install `yarn` binaries"

  def install
    rm_f Dir["bin/*.cmd", "sbin/*.cmd", "libexec/*.cmd", "etc/hadoop/*.cmd"]
    libexec.install %w[bin sbin libexec share etc]

    hadoop_env = Language::Java.java_home_env("11")
    hadoop_env[:HADOOP_LOG_DIR] = var/"hadoop"

    (libexec/"bin").each_child do |path|
      (bin/File.basename(path)).write_env_script path, hadoop_env
    end
    (libexec/"sbin").each_child do |path|
      (sbin/File.basename(path)).write_env_script path, hadoop_env
    end
    libexec.glob("libexec/*.sh").each do |path|
      (libexec/File.basename(path)).write_env_script path, hadoop_env
    end

    # Temporary fix until https://github.com/Homebrew/brew/pull/4512 is fixed
    chmod 0755, libexec.glob("*.sh")
  end

  test do
    system bin/"hadoop", "fs", "-ls"

    # Test if resource manager can start successfully
    port = free_port
    classpaths = %w[
      etc/hadoop
      share/hadoop/common/lib/*
      share/hadoop/common/*
      share/hadoop/hdfs
      share/hadoop/hdfs/lib/*
      share/hadoop/hdfs/*
      share/hadoop/mapreduce/*
      share/hadoop/yarn
      share/hadoop/yarn/lib/*
      share/hadoop/yarn/*
      share/hadoop/yarn/timelineservice/*
      share/hadoop/yarn/timelineservice/lib/*
    ].map { |path| libexec/path }

    pid = Process.spawn({
      "JAVA_HOME" => Language::Java.java_home("11"),
      "CLASSPATH" => classpaths.join(":"),
    }, Formula["openjdk@11"].opt_bin/"java", "org.apache.hadoop.yarn.server.resourcemanager.ResourceManager",
                                             "-Dyarn.resourcemanager.webapp.address=127.0.0.1:#{port}")
    sleep 8

    Process.getpgid pid
    system "curl", "http://127.0.0.1:#{port}"
  ensure
    Process.kill "TERM", pid
  end
end
