class Gcli < Formula
  desc "Portable Git(hub|lab|tea)/Forgejo/Bugzilla CLI tool"
  homepage "https://herrhotzenplotz.de/gcli/"
  url "https://github.com/herrhotzenplotz/gcli/archive/refs/tags/v2.10.0.tar.gz"
  sha256 "500da41d29fa53ab412a81864624b9e2bcd0785be61234f6cfb6b3b031b83280"
  license "BSD-2-Clause"
  revision 1
  head "https://github.com/herrhotzenplotz/gcli.git", branch: "trunk"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e46d89101a0b994695bd65f448010d24f0359f634be38c003747d890424b75aa"
    sha256 cellar: :any,                 arm64_sequoia: "cd0a602c06c4e63a3f0b5b23e8afb4c56368df7438f9d3e184f3d8faf63e5b87"
    sha256 cellar: :any,                 arm64_sonoma:  "39c4bf37f5711537b257f287a344ce8a9e88e368dc0c61e958a5416174f14d73"
    sha256 cellar: :any,                 sonoma:        "b587dfed644416217f2756b4bc39da40fb093557fd0923d87324987597f8a425"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ce5b5865ab2fb2a74b6201ba15df1f5dd0d92dfd755463ae3b0c86999cb80213"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "41a5d5e55df695feafeeea1f5c7b761924d6ee8b641cfc474cffdbff47fc7684"
  end

  depends_on "pkgconf" => :build
  depends_on "readline" => :build
  depends_on "lowdown"
  depends_on "openssl@3"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "curl"
  uses_from_macos "libedit"

  def install
    # Do not use `*std_configure_args`, `./configure` script throws errors if unknown flag is passed
    system "./configure", "--prefix=#{prefix}", "--release"
    system "make", "install"
  end

  test do
    assert_match "gcli: error: no account specified or no default account configured",
      shell_output("#{bin}/gcli -t github repos 2>&1", 1)
    assert_match(/FORK\s+VISBLTY\s+DATE\s+FULLNAME/,
      shell_output("#{bin}/gcli -t github repos -o linus"))
  end
end
