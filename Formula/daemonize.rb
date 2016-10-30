class Daemonize < Formula
  desc "Run a command as a UNIX daemon"
  homepage "http://software.clapper.org/daemonize/"
  url "https://github.com/bmc/daemonize/archive/release-1.7.7.tar.gz"
  sha256 "b3cafea3244ed5015a3691456644386fc438102adbdc305af553928a185bea05"

  bottle do
    cellar :any_skip_relocation
    sha256 "50c47ba9d070c10807b1861688082c2a242f0f2df6f6fd021da9e061fabc8806" => :sierra
    sha256 "cc17945de7476011059bcb7541776a02db3db45566af2ef86780b4d468fe1d14" => :el_capitan
    sha256 "badaed3738790f69926bbc9cc377b9d4a12c1972e004261cf492a9460cd9d3ca" => :yosemite
    sha256 "a05ef16ac15480ea28e235288ba025a75a7017e03ab0df48b08cceb255416032" => :mavericks
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    dummy_script_file = testpath/"script.sh"
    output_file = testpath/"outputfile.txt"
    pid_file = testpath/"pidfile.txt"
    dummy_script_file.write <<-EOS.undent
      #!/bin/sh
      echo "#{version}" >> "#{output_file}"
    EOS
    chmod 0700, dummy_script_file
    system "#{sbin}/daemonize", "-p", pid_file, dummy_script_file
    assert(File.exist?(pid_file), "The file containing the PID of the child process was not created.")
    sleep(4) # sleep while waiting for the dummy script to finish
    assert(File.exist?(output_file), "The file which should have been created by the child process doesn't exist.")
    assert_match version.to_s, output_file.read
  end
end
