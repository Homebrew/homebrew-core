class Mle < Formula
  desc "Flexible terminal-based text editor"
  homepage "https://github.com/adsr/mle"
  url "https://github.com/adsr/mle/archive/refs/tags/v1.7.2.tar.gz"
  sha256 "5275fcfc58d3d4890d074077d94497db488b2648287b3e48e67b00ea517b02ba"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "aaf1838843db7b6638185bbd393cbc7ab9e3b3984407717ef687428b02ede51b"
    sha256 cellar: :any,                 arm64_sequoia: "0afc101c6ed8bb562ed508f6001d593748b7f9ec2d49957282c98a59f268bcce"
    sha256 cellar: :any,                 arm64_sonoma:  "afb603d1ff975d3b8a949b0cafbf0f3e9c218d289ec0925c21f0810cc4f08178"
    sha256 cellar: :any,                 sonoma:        "efcd5533acea7fbc1174852ce5b540b40b95d56b213da0371a3d790d15815978"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8561075351cd517bf08589ef66ed0065a176971b02879b3fa397b3c21f2814b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8c209ffdf0f454441364be26612eeeb905019ad59d000a10eef17d00fab8b750"
  end

  depends_on "uthash" => :build
  depends_on "lua@5.4"
  depends_on "pcre2"

  def install
    system "make", "install", "prefix=#{prefix}"
  end

  test do
    output = pipe_output("#{bin}/mle -M 'test C-e space w o r l d enter' -p test", "hello")
    assert_equal "hello world\n", output
  end
end
