class Giter8 < Formula
  desc "Generate files and directories from templates in a git repo"
  homepage "https://github.com/foundweekends/giter8"
  url "https://github.com/foundweekends/giter8/archive/v0.9.0.tar.gz"
  sha256 "7252cde2c0249119b13bc17108713e309daf1dee46d52f160a39b61c4e1f6ab4"

  bottle do
    cellar :any_skip_relocation
    sha256 "9621b859cafeda7d9d6d52228b6d5c251147256b473db85fcfba9ac84c8d5317" => :sierra
    sha256 "97ef6c779e1b99ebcdc474ff1ad07a3d2d4c510629d4c3b30e6abed9104e1d9b" => :el_capitan
    sha256 "85b7e2737383ffdd21a6eba386b492bb2aa06d6084cf133b243755610533a06a" => :yosemite
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
