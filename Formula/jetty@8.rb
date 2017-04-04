class JettyAT8 < Formula
  desc "Java servlet engine and webserver"
  homepage "https://www.eclipse.org/jetty/"
  url "https://eclipse.org/downloads/download.php?file=/jetty/8.1.15.v20140411/dist/jetty-distribution-8.1.15.v20140411.tar.gz&r=1"
  version "8.1.15"
  sha256 "2015725c8d1525f6d57b24ab5b16c745945a7a278dbedd1fba62016be125fb84"

  bottle do
    cellar :any_skip_relocation
    sha256 "48747f0f47c63bb90688024bbea60faac0fb1f46a336ba8c56b5b1c275016115" => :sierra
    sha256 "48747f0f47c63bb90688024bbea60faac0fb1f46a336ba8c56b5b1c275016115" => :el_capitan
    sha256 "48747f0f47c63bb90688024bbea60faac0fb1f46a336ba8c56b5b1c275016115" => :yosemite
  end

  def install
    rm_rf Dir["bin/*.{cmd,bat]}"]

    libexec.install Dir["*"]
    (libexec+"logs").mkpath

    bin.mkpath
    Dir["#{libexec}/bin/*.sh"].each do |f|
      scriptname = File.basename(f, ".sh")
      (bin+scriptname).write <<-EOS.undent
        #!/bin/bash
        JETTY_HOME=#{libexec}
        #{f} $@
      EOS
      chmod 0755, bin+scriptname
    end
  end
end
