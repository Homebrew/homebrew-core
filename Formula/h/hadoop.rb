class Hadoop < Formula
  desc "Framework for distributed processing of large data sets"
  homepage "https://hadoop.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=hadoop/common/hadoop-3.4.3/hadoop-3.4.3.tar.gz"
  mirror "https://archive.apache.org/dist/hadoop/common/hadoop-3.4.3/hadoop-3.4.3.tar.gz"
  sha256 "ca65b67a9cdad27b3aa1cb81496a3136de572bab3e8f2289c2aade965f687353"
  license "Apache-2.0"

  livecheck do
    url "https://hadoop.apache.org/releases.html"
    regex(/href=.*?hadoop[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c2857c82afa8e3d419db199214486108eb2a3169f207940ad3ba71e3f2028763"
  end

  # WARNING: Check https://cwiki.apache.org/confluence/display/HADOOP/Hadoop+Java+Versions before updating JDK version
  depends_on "openjdk@11"

  conflicts_with "corepack", because: "both install `yarn` binaries"
  conflicts_with "yarn", because: "both install `yarn` binaries"

  def install
    rm(Dir["bin/*.cmd", "sbin/*.cmd", "libexec/*.cmd", "etc/hadoop/*.cmd"])
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
