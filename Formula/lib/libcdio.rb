class Libcdio < Formula
  desc "Compact Disc Input and Control Library"
  homepage "https://savannah.gnu.org/projects/libcdio/"
  url "https://github.com/libcdio/libcdio/releases/download/2.2.0/libcdio-2.2.0.tar.gz"
  sha256 "1b6c58137f71721ddb78773432d26252ee6500d92d227d4c4892631c30ea7abb"
  license "GPL-3.0-or-later"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "1a05d43f9bfaf6ae9d98ea2ee4130270809bf9b0cb03c8db4a920207575c421a"
    sha256 cellar: :any,                 arm64_sequoia: "04bc4ddb58d98fa51c6fa0a8eed1b943b7d503432232c87ff3543d9f4377950a"
    sha256 cellar: :any,                 arm64_sonoma:  "df4a0ca43f3cb7081a13dd27af54539628259a55b00903d33c57e025d9674ee7"
    sha256 cellar: :any,                 arm64_ventura: "ee59e92928e52ec430a22e42664cb30312c77b89a5f9142a984841c129b03b6d"
    sha256 cellar: :any,                 sonoma:        "40dfe0a999ecbb9daf288bd22512152d4bd51de75c6970ced86bffa556e5cd3a"
    sha256 cellar: :any,                 ventura:       "082c88816cd181eb9b11f93a8efc07b699fa2bc07ee6891c98d2ec2250dc4392"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8db10577fa1ee081c45c704784b84e16671813ac8030890989b6673808337efc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9526b1ceafc1de7a14e44eef691aa7c863b68d6df90f33cdfd5d5763022c4aa7"
  end

  depends_on "pkgconf" => :build

  def install
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cd-info -v", 1)
  end
end
