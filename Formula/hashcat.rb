class Hashcat < Formula
  desc "World's fastest and most advanced password recovery utility"
  homepage "https://hashcat.net/hashcat/"
  version_scheme 1

  head "https://github.com/hashcat/hashcat.git"

  stable do
    url "https://hashcat.net/files/hashcat-4.0.0.tar.gz"
    # Note the mirror will return 301 until the version becomes outdated.
    mirror "https://hashcat.net/files_legacy/hashcat-4.0.0.tar.gz"
    sha256 "9e8cb81bf26024eca2e117ddf8fd16316af3dd337ecf4e9917acbb1720c13b50"

    # Upstream commit from 28 Oct 2017 "fixes #1412: sed for VERSION_EXPORT
    # fixed compilation problem"
    # See https://github.com/hashcat/hashcat/commit/c06c5ddd4857b0a5d7862451da431c42287918ce
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/284f381/hashcat/VERSION_TAG.patch"
      sha256 "9dbde3d9b6ac22145fa328d53eaf8b1da0720fde7e064b71202d126655d55ebe"
    end
  end

  bottle do
    sha256 "3914d565db914d88388da81649a040da53cf89cd23b4fe56937f9b66278d903d" => :high_sierra
    sha256 "dae4e47155597707b4b3a4fec6cfb07f41c4c14bbb082a5aa1c976f63d04f842" => :sierra
    sha256 "c2b3ff55dbf3b1727dcdc109b43d5f7277495d320235621d08e24cce2d633635" => :el_capitan
    sha256 "dbcfaade00d07347efccf5f8e1966bc3ad249b7c4f95649ada5c5e2796854afa" => :yosemite
  end

  depends_on "gnu-sed" => :build

  # Upstream could not fix OpenCL issue on Mavericks.
  # https://github.com/hashcat/hashcat/issues/366
  # https://github.com/Homebrew/homebrew-core/pull/4395
  depends_on :macos => :yosemite

  def install
    system "make", "CC=#{ENV.cc}", "PREFIX=#{prefix}"

    # Fix "install: mkdir /usr/local/Cellar/hashcat/4.0.0/share: File exists"
    # Reported 28 Oct 2017 https://github.com/hashcat/hashcat/issues/1414
    ENV.deparallelize

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
