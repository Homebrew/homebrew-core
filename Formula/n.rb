class N < Formula
  desc "Node version management"
  homepage "https://github.com/tj/n"
  url "https://github.com/tj/n/archive/v5.0.1.tar.gz"
  sha256 "a913f885f6b422779b451510df8b079e4e3504e6cfba72ff3e7d9fdba4db1e82"
  head "https://github.com/tj/n.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b753e68ce91be4af36cec742a7e6d7a2cb3242fe09ba5a4147a463a80d47e2c2" => :mojave
    sha256 "b753e68ce91be4af36cec742a7e6d7a2cb3242fe09ba5a4147a463a80d47e2c2" => :high_sierra
    sha256 "4d118086a61cd984b8459fb2144d03ed3ec35e62da7ed5b04f0f1a7578827d54" => :sierra
  end

  def install
    bin.mkdir
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    system bin/"n", "ls"
  end
end
