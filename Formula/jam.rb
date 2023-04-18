class Jam < Formula
  desc "Make-like build tool"
  homepage "https://www.perforce.com/documentation/jam-documentation"
  url "https://swarm.workshop.perforce.com/projects/perforce_software-jam/download/main/jam-2.6.1.zip"
  sha256 "72ea48500ad3d61877f7212aa3d673eab2db28d77b874c5a0b9f88decf41cb73"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ae7aceb6a763b9da9860724b7347f2449f4983c004d3b58bdb21580deeb45482"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c63b8dd9caebb84eed84bd05412e698106c41dae126fefe7b5c4e713edcf827a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4c203e7cd06975b4a931ef7f79b150f3275c2b875aefc050893e7f7ffab76293"
    sha256 cellar: :any_skip_relocation, ventura:        "4a163487e3a73e5df99989d796356585e204928634e96c708199f49d68feb864"
    sha256 cellar: :any_skip_relocation, monterey:       "e523ce38232f61b98a93132faba3c61f5a1ef8cfd08d9d650a716d6b6c90daa0"
    sha256 cellar: :any_skip_relocation, big_sur:        "8ec0896e57af05a0d2e6bfdb508e77b2b45d8fcea5baa82f00f5d0a8cf2b75d4"
    sha256 cellar: :any_skip_relocation, catalina:       "0f2f2b4cac48c2ef9b11d86867c4e9d941a41a582754bfc470da25a7174dde9f"
    sha256 cellar: :any_skip_relocation, mojave:         "c19a32cbe0ffa2e7d2d826ee542a74307ca29b34ba28dc5ec6aea7ff7a9127c1"
    sha256 cellar: :any_skip_relocation, high_sierra:    "2927cebface8a3cbc00a23e7badb9e1676fda9bae282e78a1772b99aafba5014"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b3ff63ae4c707cc78f68f75b1ce99759a3c854ac61ad9774484eec62b235a2cf"
  end

  # The "Jam Documentation" page has a banner stating:
  # "Perforce is no longer actively contributing to the Jam Open Source project.
  # The last Perforce release of Jam was version 2.6 in August of 2014. We will
  # keep the Perforce-controlled links and information posted here available
  # until further notice."
  # Commented out while this formula still has dependents.
  # deprecate! date: "2021-07-10", because: :unmaintained

  conflicts_with "ftjam", because: "both install a `jam` binary"

  def install
    system "make", "CC=#{ENV.cc}", "CFLAGS=#{ENV.cflags}", "LOCATE_TARGET=bin"
    bin.install "bin/jam", "bin/mkjambase"
  end

  test do
    (testpath/"Jamfile").write <<~EOS
      Main jamtest : jamtest.c ;
    EOS

    (testpath/"jamtest.c").write <<~EOS
      #include <stdio.h>

      int main(void)
      {
          printf("Jam Test\\n");
          return 0;
      }
    EOS

    assert_match "Cc jamtest.o", shell_output(bin/"jam")
    assert_equal "Jam Test", shell_output("./jamtest").strip
  end
end
