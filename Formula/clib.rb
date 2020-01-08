class Clib < Formula
  desc "Package manager for C programming"
  homepage "https://github.com/clibs/clib"
  url "https://github.com/clibs/clib/archive/1.11.2.tar.gz"
  sha256 "5f44c4ac8e2f59b38f7a639c6d842eacf8fc8f7c53ba9b88dc75ef2fb902f630"
  head "https://github.com/clibs/clib.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d3b55a5ba14628e7f8b32377d93cb8164590085ba5cec16d2e30a070dd7b54b1" => :catalina
    sha256 "0064c509f82dee2573c26f7b729c388d8ec5f933764ec6319273c9d0e7394890" => :mojave
    sha256 "c0f0ea0743559f82cfbe4bc0437aec7a99653a8004d10930990b2e921e2f40ee" => :high_sierra
  end

  uses_from_macos "curl"

  def install
    ENV["PREFIX"] = prefix
    system "make", "install"
  end

  test do
    system "#{bin}/clib", "install", "stephenmathieson/rot13.c"
  end
end
