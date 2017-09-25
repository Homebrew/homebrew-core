class Giter8 < Formula
  desc "Generate files and directories from templates in a git repo"
  homepage "https://github.com/foundweekends/giter8"
  url "https://github.com/foundweekends/giter8/archive/v0.10.0.tar.gz"
  sha256 "f9e3b26a7e154421f1a3c77941ee0f4bf8b04835f9810c9f46425871bb9cbb02"

  bottle do
    cellar :any_skip_relocation
    sha256 "d802cf462c8283e0c9663a61dde82bce7d482da24b2ce71b2cb233e5c589e362" => :high_sierra
    sha256 "3841b04b665c9121d698fadfe94d4dc0ccaa4c5b36d7a590d54186c7d7583afc" => :sierra
    sha256 "1d45736f60b6fdb1af3e2ee607b256caa99536e27a237d2f834fe2d3fb15326f" => :el_capitan
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
