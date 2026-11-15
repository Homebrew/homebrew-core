class Jq < Formula
  desc "Lightweight and flexible command-line JSON processor"
  homepage "https://jqlang.github.io/jq/"
  url "https://github.com/jqlang/jq/releases/download/jq-1.8.2/jq-1.8.2.tar.gz"
  sha256 "71b8d6e8f5fe81f6c6d0d110e3892251f6ce76ed095abd315e26e6e1193af3af"
  license "MIT"
  compatibility_version 1

  livecheck do
    url :stable
    regex(/^(?:jq[._-])?v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "d048dd4c28d867e939065a3bc8209f37e2a5be3e2c18d18c8c7da8f4d1629a4a"
    sha256 cellar: :any, arm64_tahoe:       "ca67c64d0aaf1e5472790ec2cc081ff7972316f27095d8a8aab81b3321247036"
    sha256 cellar: :any, arm64_sequoia:     "ef70e236f58a8a781436ee400f9bdf847ad7d12e75115871fb6a94b9214a1a41"
    sha256 cellar: :any, arm64_sonoma:      "39f30266edd431962b606353091035a9cec9a61437252f448a3a8cf69dbc0551"
    sha256 cellar: :any, sonoma:            "af9ddba2379910ceed96961891002b1c8c133f6f3f290ccb3d7c7d877dd4e9e9"
    sha256 cellar: :any, arm64_linux:       "d67a00e578f6684163660fed1accb56ef87b01651e37dec737d362d09ece9eab"
    sha256 cellar: :any, x86_64_linux:      "631787d9b19df5e5557cc83f972080e541f543f8df2d1f212ca4290ff23e9764"
  end

  head do
    url "https://github.com/jqlang/jq.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "oniguruma"

  deny_network_access!

  def install
    system "autoreconf", "--force", "--install", "--verbose" if build.head?
    system "./configure", *std_configure_args,
                          "--disable-silent-rules",
                          "--disable-maintainer-mode"
    system "make", "install"
  end

  test do
    assert_equal "2\n", pipe_output("#{bin}/jq .bar", '{"foo":1, "bar":2}')
  end
end
