class Pdsh < Formula
  desc "Efficient rsh-like utility, for using hosts in parallel"
  homepage "https://github.com/chaos/pdsh"
  url "https://github.com/chaos/pdsh/releases/download/pdsh-2.34/pdsh-2.34.tar.gz"
  sha256 "b47b3e4662736ef44b6fe86e3d380f95e591863e69163aa0592e9f9f618521e9"
  license "GPL-2.0"
  head "https://github.com/chaos/pdsh.git", branch: "master"

  bottle do
    sha256 arm64_monterey: "4f4123b72684e34e5e78b67269da1aae6e29e0ae60d1f144754d521289230d5a"
    sha256 arm64_big_sur:  "08092fc19817b2eb4fbbb1ffe7849246f7a8c0cfc1b3493d631f41b77ab68de6"
    sha256 monterey:       "6f62900a3ebb6760631932fab7cf15c6cc3a12f2c2c8d390a46710f157716baf"
    sha256 big_sur:        "c9865e6ec25dd5d76c412919c161377a73e0e72f53b97c433488377ea6c69ece"
    sha256 catalina:       "db103afd01523d00761df3c077b309ffeaa7e816a538ab9b739fac7b58a8171b"
    sha256 mojave:         "d5ce164360edacbda30b059e8964fc6e4c886adc5f63218a37667756419ef51a"
    sha256 high_sierra:    "4063ea4d575eef74e2af6993a74658df6c48e42b81df8a77a49aee745c7527a0"
    sha256 x86_64_linux:   "02ddcbc57a480f8a5f049e6f50de9621b7eb6f84ca6e52ecd91a8747035641b6"
  end

  depends_on "readline"

  def install
    args = %W[
      --prefix=#{prefix}
      --mandir=#{man}
      --with-nodeupdown
      --with-readline
      --with-ssh
      --with-dshgroups
      --with-netgroup
      --with-slurm
      --without-rsh
      --without-xcpu
    ]

    system "./configure", *args
    system "make", "install"
  end

  test do
    system "#{bin}/pdsh", "-V"
  end
end
