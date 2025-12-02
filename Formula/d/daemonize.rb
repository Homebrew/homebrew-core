class Daemonize < Formula
  desc "Run a command as a UNIX daemon"
  homepage "https://software.clapper.org/daemonize/"
  url "https://github.com/bmc/daemonize/archive/refs/tags/release-1.7.8.tar.gz"
  sha256 "20c4fc9925371d1ddf1b57947f8fb93e2036eb9ccc3b43a1e3678ea8471c4c60"
  license "BSD-3-Clause"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "44f7c8ffc66e91dd8390c9918dfac5d913fb1ff3099a5e29965b49e6c4560c21"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "ac1001a5e4588bc098b708492cf6c90fe91b88ae7c28be94038fa25d1d15aaea"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "36f15dfa0b033d4e984a19e769caae8a42a3e4facf10d87f54f68ec275ae10ce"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fd11e888912a0afdfac36c26b95f4d27b7aafaa2ce3ac41c14388683f9027df0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2b4a5d09904220ebd65f8fb46dc9ff521fe01fd024a80d1fbcf587ff5324e21f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "49b53c082bc201f7dcfe760c727b7f748ce6306fcdbf656d1609384dc75e52fc"
    sha256 cellar: :any_skip_relocation, sonoma:         "150530a6f011ca60ce9ed72707c51d2a31c2260e7b4540afbed8c35bc718c765"
    sha256 cellar: :any_skip_relocation, ventura:        "d271ade4fea6639e817bb38815fde49a53e006a5b51a60f4d0b54fb08e07337d"
    sha256 cellar: :any_skip_relocation, monterey:       "4c32da9480f4d9f48e28390f9201c7667dfabbb874f5acd4e7af28b04de2e748"
    sha256 cellar: :any_skip_relocation, big_sur:        "a9dc01cd71295518a9477676bee344b3f3f25d5725777635c0c708d8dc7fdde0"
    sha256 cellar: :any_skip_relocation, catalina:       "a5c898ee425aecfb5c3d41e75da436ebbd44ad2fa343fa85b60573bd4fd8c7a7"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "5f2837cbc66d881b57213af108138f2b18bc05a5ade76c9ae7ce5dc4ca515781"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ccae89928e0e598a4b36e6077c509bb4a36020519b4aa49aa3bd58b42de2a3ce"
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
    dummy_script_file.write <<~SH
      #!/bin/sh
      echo "#{version}" >> "#{output_file}"
    SH
    chmod 0700, dummy_script_file
    system "#{sbin}/daemonize", "-p", pid_file, dummy_script_file
    assert_path_exists pid_file, "The file containing the PID of the child process was not created."
    sleep(4) # sleep while waiting for the dummy script to finish
    assert_path_exists output_file, "The file which should have been created by the child process doesn't exist."
    assert_match version.to_s, output_file.read
  end
end
