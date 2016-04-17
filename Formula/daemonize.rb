class Daemonize < Formula
  desc "Run a command as a UNIX daemon"
  homepage "http://software.clapper.org/daemonize/"
  url "https://github.com/bmc/daemonize/archive/release-1.7.7.tar.gz"
  sha256 "b3cafea3244ed5015a3691456644386fc438102adbdc305af553928a185bea05"

  bottle do
    cellar :any_skip_relocation
    sha256 "5858614b5ecf028c60e72a560beaeb8dc8fe098919336595ff86d68318addd4c" => :el_capitan
    sha256 "f030b352d61fa673e81d84ee041c6922f3615cb7761b68e090329a406248d322" => :yosemite
    sha256 "a8713e370c1c2677bff6bfd30722eefa79daca3352a6e79d6dc4315b782bea61" => :mavericks
    sha256 "94bb0d065fd5e3a7fe43ae3df279e7eac2c6c65455bf2821981a838789365435" => :mountain_lion
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
