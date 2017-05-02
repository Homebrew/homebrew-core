class Giter8 < Formula
  desc "Generate files and directories from templates in a git repo"
  homepage "https://github.com/foundweekends/giter8"
  url "https://github.com/foundweekends/giter8/archive/v0.8.0.tar.gz"
  sha256 "f3a49b559b5438d5f28d30bf5c40c607823e6d968aaeeff231eedd17f38f2b4e"

  bottle do
    cellar :any_skip_relocation
    sha256 "bcc901d03b43c6ed8604623900261f8a88c288506d70d4ce3cf37bc49f0eae58" => :sierra
    sha256 "e7a62369645174ff5593ae3b17a42858d6aa3bf45637d6bff6c3d4ffc25e3b76" => :el_capitan
    sha256 "954c03fe0f4bdaa0164919533385c0a6a8177fc0b7edfb07291d760b0a596770" => :yosemite
  end

  depends_on :java => "1.6+"

  resource "conscript" do
    url "https://github.com/foundweekends/conscript.git",
        :tag => "v0.5.1",
        :revision => "0a196fbb0bd551cd7b00196b4032dea2564529ce"
  end

  resource "launcher" do
    url "https://oss.sonatype.org/content/repositories/public/org/scala-sbt/launcher/1.0.1/launcher-1.0.1.jar"
    sha256 "10a12180a6bc3c72f5d4732a74f2c93abfd90b9b461cf2ea53e0cc4b4f9ef45c"
  end

  def install
    conscript_home = libexec/"conscript"
    ENV["CONSCRIPT_HOME"] = conscript_home
    ENV.java_cache

    conscript_home.install resource("launcher")
    launcher = conscript_home/"launcher-#{resource("launcher").version}.jar"
    conscript_home.install_symlink launcher => "sbt-launch.jar"

    resource("conscript").stage do
      cs = conscript_home/"foundweekends/conscript/cs"
      cs.install "src/main/conscript/cs/launchconfig"

      inreplace "setup.sh" do |s|
        # outdated launcher reported 17 Apr 2017 https://github.com/foundweekends/conscript/issues/122
        s.gsub! /^LJV=1.0.0$/, "LJV=1.0.1"

        s.gsub! /.*wget .*/, ""
        s.gsub! /^ +exec .*/, "exit"
      end
      system "sh", "-x", "setup.sh" # exit code is 1
    end

    system conscript_home/"bin/cs", "foundweekends/giter8/#{version}"
    bin.install_symlink conscript_home/"bin/g8"
  end

  test do
    # sandboxing blocks us from locking libexec/"conscript/boot/sbt.boot.lock"
    cp_r libexec/"conscript", "."
    inreplace %w[conscript/bin/cs conscript/bin/g8
                 conscript/foundweekends/giter8/g8/launchconfig
                 conscript/foundweekends/conscript/cs/launchconfig],
      libexec, testpath
    system testpath/"conscript/bin/g8", "--version"
  end
end
