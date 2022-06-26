class Gnuski < Formula
  desc "Open source clone of Skifree"
  homepage "https://gnuski.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/gnuski/gnuski/gnuski-0.3/gnuski-0.3.tar.gz"
  sha256 "1b629bd29dd6ad362b56055ccdb4c7ad462ff39d7a0deb915753c2096f5f959d"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5ffb1f95f60f2e9244ccd431e72aab1fd4b44b8b7cf684efab6965d5540c853d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d82abb34deac302a464e7c664a3dcf0726f1d0f8ee03586b195e3449a2c83d43"
    sha256 cellar: :any_skip_relocation, monterey:       "313b0cefe9c2c2ffa45f1bee439feb5a28ca2c3fcce32bfa566534f6c3cad725"
    sha256 cellar: :any_skip_relocation, big_sur:        "6ae8c77ab5fed3e5f85be1c411cc631099d219bd49ddb3a35f527da27894b880"
    sha256 cellar: :any_skip_relocation, catalina:       "7c58085b5ceb98168c728003d484e08410c837bde9b044ed5a5fa6f26796d9ab"
    sha256 cellar: :any_skip_relocation, mojave:         "4fe7b21e4b40ee72c7825c1e0330a958694b98529121385b78b7af9aff229d6d"
    sha256 cellar: :any_skip_relocation, high_sierra:    "6f15bd497951ea784e84b2ec888be83343ad1ad96eb6bab9ba343bff31246700"
    sha256 cellar: :any_skip_relocation, sierra:         "3874907a4ad715492c026d969ec3265dcd5f71424dde07a83aa1c21a1e36fa38"
    sha256 cellar: :any_skip_relocation, el_capitan:     "ce14d8ee8b8d58c710b93adb2f4cedfb9d78fb64746f38daee4ea38aa977ae43"
    sha256 cellar: :any_skip_relocation, yosemite:       "3163ed8b9f1487e0f5f5a42006e0edfbfdb3a4dbea9b917c0aa692db282ec13b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "19ecc1577888f0186d9880b9048a0fa9e4bdf931d3f2710adf807419f7a64310"
  end

  uses_from_macos "ncurses"

  def install
    system "make"
    bin.install "gnuski"
  end
end
