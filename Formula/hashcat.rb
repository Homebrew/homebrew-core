class Hashcat < Formula
  desc "World's fastest and most advanced password recovery utility"
  homepage "https://hashcat.net/hashcat/"
  # Note the mirror will return 301 until the version becomes outdated.
  url "https://hashcat.net/files/hashcat-4.1.0.tar.gz"
  mirror "https://hashcat.net/files_legacy/hashcat-4.1.0.tar.gz"
  sha256 "bd23997153c5a8c8b35da3931ff74a808561399de3f3e07058ff4d2f8617119c"
  version_scheme 1
  head "https://github.com/hashcat/hashcat.git"

  bottle do
    sha256 "64c94a9eff257fda38a37f0dfcde9b88074e5ca1fe63a91cca2128983777f536" => :high_sierra
    sha256 "437cac49dbd5807c757a9613356c02705e237b57ef3b246e827635f086c5289c" => :sierra
    sha256 "8d7aa78dac5d730e10be563651d9955bc82d1a8ab63860af844454618876be00" => :el_capitan
  end

  depends_on "gnu-sed" => :build

  # Upstream could not fix OpenCL issue on Mavericks.
  # https://github.com/hashcat/hashcat/issues/366
  # https://github.com/Homebrew/homebrew-core/pull/4395
  depends_on :macos => :yosemite

  def install
    system "make", "CC=#{ENV.cc}", "PREFIX=#{prefix}"
    system "make", "install", "CC=#{ENV.cc}", "PREFIX=#{prefix}"
  end

  test do
    #
    # General test settings
    #

    binary    = "./hashcat"
    pass      = "hash234"
    hash_type = "500" # -m 500 = md5crypt, MD5(Unix), FreeBSD MD5, Cisco-IOS MD5

    dict_file = "example.dict"
    hash_file = "example#{hash_type}.hash"

    additional_args = " --force" +         # shouldn't be needed with a correct OpenCL installation
                      " --quiet" +         # we only need the hash:pass pair in the output
                      " --potfile-disable" # we do not need to check or write the hashcat.potfile

    #
    # Copy some files to the test folder
    #

    # copy all files from share to the test folder
    cp_r pkgshare.children, testpath

    # copy the example hash and the dictionary file to the test folder
    cp "#{doc}/#{hash_file}", testpath
    cp "#{doc}/#{dict_file}", testpath

    # copy the hashcat binary to the test folder
    cp "#{bin}/#{binary}", testpath

    #
    # Test 1 (dictionary attack, -a 0):
    #

    hash = File.open(hash_file, "rb") { |f| f.read.strip }

    attack_mode = "0"

    cmd = binary + " -m " + hash_type + " -a " + attack_mode + additional_args + " " + hash_file + " " + dict_file

    # suppress STDERR output
    cmd += " 2>/dev/null"

    assert_equal "#{hash}:#{pass}", shell_output(cmd).strip

    #
    # Test 2 (combinator attack, -a 1):
    #

    attack_mode = "1"

    dict1 = "dict1.txt"
    dict2 = "dict2.txt"

    File.write(dict1, pass[0..3])
    File.write(dict2, pass[4..-1])

    cmd = binary + " -m " + hash_type + " -a " + attack_mode + additional_args + " " + hash_file + " " + dict1 + " " + dict2

    # suppress STDERR output
    cmd += " 2>/dev/null"

    assert_equal "#{hash}:#{pass}", shell_output(cmd).strip

    #
    # Test 3 (mask attack, -a 3):
    #

    attack_mode = "3"

    mask = "?l?l?l" + pass[3..-1]

    cmd = binary + " -m " + hash_type + " -a " + attack_mode + additional_args + " " + hash_file + " " + mask

    # suppress STDERR output
    cmd += " 2>/dev/null"

    assert_equal "#{hash}:#{pass}", shell_output(cmd).strip

    #
    # Test 4 (hybrid attack, dict + mask, -a 6):
    #

    attack_mode = "6"

    mask = "?d?d?d"

    cmd = binary + " -m " + hash_type + " -a " + attack_mode + additional_args + " " + hash_file + " " + dict1 + " " + mask

    # suppress STDERR output
    cmd += " 2>/dev/null"

    assert_equal "#{hash}:#{pass}", shell_output(cmd).strip

    #
    # Test 5 (hybrid attack, mask + dict, -a 7):
    #

    attack_mode = "7"

    mask = "?l?l" + pass[2..3]

    cmd = binary + " -m " + hash_type + " -a " + attack_mode + additional_args + " " + hash_file + " " + mask + " " + dict2

    # suppress STDERR output
    cmd += " 2>/dev/null"

    assert_equal "#{hash}:#{pass}", shell_output(cmd).strip
  end
end
