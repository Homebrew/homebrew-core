class Eatmemory < Formula
  desc "Simple program to allocate memory from the command-line"
  homepage "https://github.com/julman99/eatmemory"
  url "https://github.com/julman99/eatmemory/archive/refs/tags/v0.1.10.tar.gz"
  sha256 "568622f6aef9e20e7d5c5bb66ab7ce74bec458415b8135921fe6d2425450b374"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9c83f4e8d97be2623b0294a9fca3c163f47690b3609475e76056c672b7ef6cca"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1c1eee494ca8c2e811b6335cb63b4764c9cdcd37996e2d0a64fa2b158fbad0ed"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4f42ceeec17165fd44a8ef7469a9255cdab561e9530b05e588ee751fbfcf6037"
    sha256 cellar: :any_skip_relocation, sonoma:         "6bb8add10952008d5593e4c2d9e4903c4f4f65cbe3514afb94a761187944c734"
    sha256 cellar: :any_skip_relocation, ventura:        "346eb2b0e8ac45cabed60c56b0509bdac73a882f1d7325ad8fd25a74c728a043"
    sha256 cellar: :any_skip_relocation, monterey:       "0311b2f66c15c17ad0734b5854a5a917ad0da06f7d20cc4f98d8ddfe205d0916"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aba9a1f17ead302e4ab2d261c51ab0efc87ad1365ae68da4cead1ccd2361e030"
  end

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    # test version match
    out = shell_output "#{bin}/eatmemory -?"
    version_escaped = version.to_s.gsub(".", '\.')
    assert_match %r{^eatmemory #{version_escaped} - https://github.com/julman99/eatmemory\n.*}, out

    # test for expected output
    out = shell_output "#{bin}/eatmemory -t 0 10M"
    assert_match( \
      /^|\nEating 10485760 bytes in chunks of 1024\.\.\.\nDone, sleeping for 0 seconds before exiting\.\.\.\n/, out
    )

    # test for memory correctly consumed
    memory_list = [10, 20, 100]
    memory_list.each do |memory_mb|
      memory_column = 5
      memory_column = 4 if OS.linux?

      fork do
        shell_output "#{prefix}/bin/eatmemory -t 60 #{memory_mb}M 2>&1"
      end
      sleep 5 # sleep to allow the forked process to initialize and eat the memory

      out = shell_output \
        "COLUMNS=500 ps aux | grep -v grep | grep -v 'sh -c' | grep '#{prefix}/bin/eatmemory -t 60 #{memory_mb}'"

      columns = out.split
      used_bytes = columns[memory_column].to_i
      assert_operator used_bytes, ">=", memory_mb * 1024
      assert_operator used_bytes, "<", memory_mb * 2 * 1024
    end
  end
end
