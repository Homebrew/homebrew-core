class Giter8 < Formula
  desc "Generate files and directories from templates in a git repo"
  homepage "https://github.com/foundweekends/giter8"
  url "https://github.com/foundweekends/giter8/archive/v0.11.0.tar.gz"
  sha256 "413ebc032d6bc57aaa4b3d6451256320cff56a13d73d5f36c4ee8d7d890f54d5"

  bottle do
    cellar :any_skip_relocation
    sha256 "29b044181c0109b44e2cf9c1ecd303d4ad06189b6da0ce8ae12f1d9682d17a2e" => :mojave
    sha256 "679fef3c2993cec5df50162c0d975dfaf6e5b7a52bab3e45cba129d7ffac0d14" => :high_sierra
    sha256 "67cd41a4fd7e296501a7711edbebf6637795f5a9b5f62543b1997dbe99ddde41" => :sierra
    sha256 "2894b4cc95e79a537fa8f279a64806f53720621f4bfc2f2bf81183ad1f99642e" => :el_capitan
  end

  depends_on :java => "1.6+"

  resource "conscript" do
    url "https://github.com/foundweekends/conscript.git",
        :tag => "v0.5.2",
        :revision => "a3904ee175cd202a5cf35ff2d2a21d999f63516a"
  end

  resource "launcher" do
    url "https://oss.sonatype.org/content/repositories/public/org/scala-sbt/launcher/1.0.1/launcher-1.0.1.jar"
    sha256 "10a12180a6bc3c72f5d4732a74f2c93abfd90b9b461cf2ea53e0cc4b4f9ef45c"
  end

  def install
    conscript_home = libexec/"conscript"
    ENV["CONSCRIPT_HOME"] = conscript_home

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
