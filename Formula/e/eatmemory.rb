class Eatmemory < Formula
  desc "Simple program to allocate memory from the command-line"
  homepage "https://github.com/julman99/eatmemory"
  url "https://github.com/julman99/eatmemory/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "02ca26cb30813563075618e1a86f2a63b0f6f3c258e5cd6f287e10ef6468e64f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c8cc9da4c3299c442a37a524d9a26ddd49d5d9186af2699bdf672682713e914d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0f23c031cd7cfe38611e5ea29acb66a9e744ca48c39469af5bd6c4786015c4db"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d73a9cc3aa13cb4044ddf95ecccb802ddbaa2aeb0e102e964644b0de3dcfcb8b"
    sha256 cellar: :any_skip_relocation, sonoma:        "2fa28eec23bd72543ab4fd2f4f4bf5215a5ec5bd9b294e53c4c175c8f098f179"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ab4f27c6a212fb78333d616168bd586c7da08144aeb1db5ae3d8209e19feb17e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1de7750bf1eecedb50d212d6e43319cf4fe8a0ff4406b9136c12c3c9422fc73f"
  end

  def install
    system "make", "install", "PREFIX=#{prefix}", "VERSION=#{version}"
  end

  test do
    # test version match
    assert_match version.to_s, shell_output("#{bin}/eatmemory --help")

    # test for expected output
    out = shell_output "#{bin}/eatmemory -t 0 10M"
    assert_match(
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
