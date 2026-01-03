class Minizign < Formula
  desc "Minisign reimplemented in Zig"
  homepage "https://github.com/jedisct1/zig-minisign"
  url "https://github.com/jedisct1/zig-minisign/archive/refs/tags/0.1.7.tar.gz"
  sha256 "e0358f68a5fe6573c7e735db45cd1b697abcef6925c922abddc20978cd20a9f1"
  license "ISC"
  head "https://github.com/jedisct1/zig-minisign.git", branch: "main"

  depends_on "zig" => :build

  def install
    system "zig", "build", *std_zig_args
  end

  test do
    # Generate a test key pair with an empty password
    IO.popen([bin/"minizign", "-G", "-s", testpath/"test.key", "-p", testpath/"test.pub"], "w") do |io|
      io.puts ""
    end
    assert_path_exists testpath/"test.key"
    assert_path_exists testpath/"test.pub"

    # Create a test file and sign it
    (testpath/"test.txt").write "Out of the mountain of despair, a stone of hope."
    system bin/"minizign", "-S", "-s", "test.key", "-m", "test.txt"
    assert_path_exists testpath/"test.txt.minisig"

    # Verify the signature
    system bin/"minizign", "-V", "-p", "test.pub", "-m", "test.txt"
  end
end
