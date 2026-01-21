class Htpdate < Formula
  desc "Synchronize time with remote web servers"
  homepage "https://www.vervest.org/htp/"
  url "https://www.vervest.org/htp/archive/c/htpdate-2.0.0.tar.gz"
  sha256 "52f25811f00dfe714e0bcf122358ee0ad74e25db3ad230d5a4196e7a62633f27"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://www.vervest.org/htp/?download"
    regex(/href=.*?htpdate[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "f6e0c03fb82e6410178392e273f6e652c46fe05c05c6b5db8f9bc668ae91ad65"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "fe928ac1ad4a1d522e627c3f4d5ff49fbb6854618915ef2e637e11b86cd48be1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7a5c342e659f6ecae78ec9b538f84da8240bde60848f6fbd3166773c44401c83"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ecdc7014e50912857698372140ac946170a739c23b41614895872586daba71c0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ef4adc85d46ad9b58f71f397295288eceaa19f98e808e50059dfe0f0a01602e7"
    sha256 cellar: :any_skip_relocation, sonoma:         "c4893b5b8412f014565d366bdb4d95feae8572a9328aa341e41e27056d26cb75"
    sha256 cellar: :any_skip_relocation, ventura:        "687a2c378cb61476b28d932c3b4de170337bdaf22003b55d82c7a50b58ef762a"
    sha256 cellar: :any_skip_relocation, monterey:       "c09f96724bae5ae13b7b84c7e76b1f0a2c8f362e6e007fd4187ad18c0afb9364"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "be4c2fa2c9b1e31a45e406d8a888a1f77200fa2355e1fbf09b27ae77ebdae007"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c769ab62c46610dd1986c757bb70a42cd446e9e0292e0fca80cd60a33e752b1e"
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
