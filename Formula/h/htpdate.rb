class Htpdate < Formula
  desc "Synchronize time with remote web servers"
  homepage "https://www.vervest.org/htp/"
  url "https://github.com/twekkel/htpdate/archive/refs/tags/v2.0.1.tar.gz"
  sha256 "4c771fe3fc5c4ab5f9393dd501bdc51e4c067297cf304ad1e74e1965ac1c066f"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "252973c63d0ffe671e5fd12a3d36e93d425d826a5f2cdc2ecb1fe61c8e93fa58"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e4b7cdf70ede339e75d8d7850c466b805da963caec24bbe618b38cece0ca7ddb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6181009ddb2265370b8b08909177e75cdfa7a07cc1a6f177028303c48af0c24c"
    sha256 cellar: :any_skip_relocation, sonoma:        "62e3483ab73cc15f974dd59dbf279c2731260735e3480c65cea451747c1bcca2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2a05e01faebc3b5662fcbd7063fc46c90832b32f345b36c639293b0b8f28dde1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c005ab298294a4e5ffa2c0d9cad5f0b30e08f60bcb4e61e0e808e32e91d2af1a"
  end

  def install
    system "make", "prefix=#{prefix}",
                   "STRIP=/usr/bin/strip",
                   "CC=#{ENV.cc}",
                   "CFLAGS=#{ENV.cflags}",
                   "install"
  end

  test do
    system sbin/"htpdate", "-q", "-d", "-u", ENV["USER"], "example.org"
  end
end
