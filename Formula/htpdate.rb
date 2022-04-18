class Htpdate < Formula
  desc "Synchronize time with remote web servers"
  homepage "https://www.vervest.org/htp/"
  url "https://www.vervest.org/htp/archive/c/htpdate-1.3.4.tar.gz"
  sha256 "744f9200cfd3b008a5516c5eb6da727af532255a329126a7b8f49a5623985642"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://www.vervest.org/htp/?download"
    regex(/href=.*?htpdate[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8fbd7789126d96fef41cd7d9fc2c74a1bf9feb5c64e92ae2892980429f2a149d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "99a88da3d42b316fec3edd327a2adc2e8f96b7f7d6f37a97d9dab08205f41c42"
    sha256 cellar: :any_skip_relocation, monterey:       "6d352630028cc7e4dd5fb4f084f4e715d0df7387fa3273b409b6068487232044"
    sha256 cellar: :any_skip_relocation, big_sur:        "87386fb83d33eb8784a9e950884d74473b49d87c7b4d258acd3a24bd648979bc"
    sha256 cellar: :any_skip_relocation, catalina:       "689c87e94f22843715a22764bed4ca130ba37c51ccdbfbb107f4892c1345208b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "600585ac1f7d5c3be35ddf23d7b0389bbeb9ba6bdabb675069a1b225ff4ff65f"
  end

  def install
    system "make", "prefix=#{prefix}",
                   "STRIP=/usr/bin/strip",
                   "CC=#{ENV.cc}",
                   "CFLAGS=#{ENV.cflags}",
                   "install"
  end

  test do
    system "#{sbin}/htpdate", "-q", "-d", "-u", ENV["USER"], "example.org"
  end
end
