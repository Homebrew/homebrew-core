class Llnode < Formula
  desc "LLDB plugin for live/post-mortem debugging of node.js apps"
  homepage "https://github.com/indutny/llnode"
  url "https://github.com/indutny/llnode/archive/v1.0.0.tar.gz"
  sha256 "fcf90201930e52b49d0fa1b369aac7b5b74c3bbffe34f423d5aa5b899267f295"

  def install
    system "git", "clone", "--depth", "1", "-b", "release_38",
        "https://github.com/llvm-mirror/lldb.git", "lldb"
    system "git", "clone", "--depth", "1",
        "https://chromium.googlesource.com/external/gyp.git", "tools/gyp"

    system "./gyp_llnode"
    system "make", "-C", "out/"
    cp "out/Release/llnode.dylib", "#{prefix}/llnode.dylib"

    mkdir_p lldb_dir
    ln_sf "#{prefix}/llnode.dylib", "#{lldb_dir}/llnode.dylib"
  end

  def lldb_dir
    "/Users/#{ENV["USER"]}/Library/Application Support/LLDB/PlugIns"
  end

  test do
    system "file", "#{lldb_dir}/llnode.dylib"
  end
end
