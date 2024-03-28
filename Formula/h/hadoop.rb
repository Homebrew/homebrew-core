class Hadoop < Formula
  desc "Framework for distributed processing of large data sets"
  homepage "https://hadoop.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=hadoop/common/hadoop-3.4.0/hadoop-3.4.0.tar.gz"
  mirror "https://archive.apache.org/dist/hadoop/common/hadoop-3.4.0/hadoop-3.4.0.tar.gz"
  sha256 "e311a78480414030f9ec63549a5d685e69e26f207103d9abf21a48b9dd03c86c"
  license "Apache-2.0"

  livecheck do
    url "https://hadoop.apache.org/releases.html"
    regex(/href=.*?hadoop[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3bc4d1af76f0d40746abffa84b42508f1ef53eda3d612b03e5c1f4144bb4826a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3bc4d1af76f0d40746abffa84b42508f1ef53eda3d612b03e5c1f4144bb4826a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3bc4d1af76f0d40746abffa84b42508f1ef53eda3d612b03e5c1f4144bb4826a"
    sha256 cellar: :any_skip_relocation, sonoma:         "090c88b44a952701c87d753f376e9465571bfdd4fcb4de38c245e217964574da"
    sha256 cellar: :any_skip_relocation, ventura:        "090c88b44a952701c87d753f376e9465571bfdd4fcb4de38c245e217964574da"
    sha256 cellar: :any_skip_relocation, monterey:       "090c88b44a952701c87d753f376e9465571bfdd4fcb4de38c245e217964574da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3bc4d1af76f0d40746abffa84b42508f1ef53eda3d612b03e5c1f4144bb4826a"
  end

  # WARNING: Check https://cwiki.apache.org/confluence/display/HADOOP/Hadoop+Java+Versions before updating JDK version
  depends_on "openjdk@11"

  conflicts_with "corepack", because: "both install `yarn` binaries"
  conflicts_with "yarn", because: "both install `yarn` binaries"

  def install
    rm_f Dir["bin/*.cmd", "sbin/*.cmd", "libexec/*.cmd", "etc/hadoop/*.cmd"]
    rm ["bin/container-executor", "bin/oom-listener", "bin/test-container-executor"]
    libexec.install %w[bin sbin libexec share etc]

    hadoop_env = Language::Java.overridable_java_home_env("11")
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
    sleep 15

    Process.getpgid pid
    system "curl", "http://127.0.0.1:#{port}"
  ensure
    Process.kill "TERM", pid
  end
end
