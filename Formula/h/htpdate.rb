class Htpdate < Formula
  desc "Synchronize time with remote web servers"
  homepage "https://www.vervest.org/htp/"
  url "https://github.com/twekkel/htpdate/archive/refs/tags/v2.0.2.tar.gz"
  sha256 "3f5effa9355db140ef8ace6d17800d48815d1afdcef9d1096510451839dd8de4"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "057a11555cba28d5467be47618b77200d9cc31d647418dcf7694596f9667c24e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "66b2ec8f126efef94c917d220cf5eb8c74970a7e04b2c0ed35f2248dacc20d3a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "79f948f71b2c94302832be6196a143c9b629a9ab5a0414813b798dd75b09eb3f"
    sha256 cellar: :any_skip_relocation, sonoma:        "61699fbc43e93d19b8982e48f909673c18ea6d1c6a7b9aa5f06836ab7443a40c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "97a122f3b6f5126971271bbcf905ec4f817cf8c778e055dc703574fbab471cc6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "518af19c1c56c703bee6ca15e239fcf35fc70546a19b467075c279b5b5bae967"
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
