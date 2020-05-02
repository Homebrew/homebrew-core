class Clib < Formula
  desc "Package manager for C programming"
  homepage "https://github.com/clibs/clib"
  url "https://github.com/clibs/clib/archive/1.11.3.tar.gz"
  sha256 "93af31d1bccfc828c185c012ab1f737d60408bd8402bcef20ed96ac337270afe"
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
