class Giter8 < Formula
  desc "Generate files and directories from templates in a git repo"
  homepage "https://github.com/n8han/giter8"
  url "https://github.com/foundweekends/giter8/archive/v0.7.1.tar.gz"
  sha256 "181357720f14b49cf132210a04fe3ad470d51731030394a8a723c1c49aced42c"

  bottle do
    cellar :any_skip_relocation
    sha256 "8fd7a060e000606113365f5d8d08a26fdffc5ebc8a0eb44e9ed61f71383ed055" => :sierra
    sha256 "26447426ee86cb6d21c1c81a9b9a0b3e6bf0502c3a4b0947536b018a7a74a2fe" => :el_capitan
    sha256 "b5570215fb623a043b60583d1b0919a4cf5850bfc7e3fb0f7a22fa18f2a2be97" => :yosemite
    sha256 "56430765ef7a29fe7929e17b4a4da636f514920c5b92349009b9d784e8ad723c" => :mavericks
  end

  depends_on :java => "1.6+"

  resource "conscript" do
    url "https://github.com/foundweekends/conscript.git",
        :revision => "f7ee8b5bc3b00592adbd09c878b6649b624f141c"
  end

  resource "launcher" do
    url "https://oss.sonatype.org/content/repositories/public/org/scala-sbt/launcher/1.0.0/launcher-1.0.0.jar"
    sha256 "9149549ee09c50bda21ab57990f95aac4dd3919d720367df6198ec7e16480639"
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
