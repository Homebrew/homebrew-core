class Arabica < Formula
  desc "XML toolkit written in C++"
  homepage "https://www.jezuk.co.uk/tags/arabica.html"
  url "https://github.com/jezhiggins/arabica/archive/refs/tags/2020-April.tar.gz"
  version "20200425"
  sha256 "b00c7b8afd2c3f17b5a22171248136ecadf0223b598fd9631c23f875a5ce87fe"
  license "BSD-3-Clause"
  head "https://github.com/jezhiggins/arabica.git", branch: "main"

  # The formula uses a YYYYMMDD version format, so we have to check the release
  # information to generate a version from the publish datetime.
  livecheck do
    url :stable
    regex(/^(\d{4}-\d{2}-\d{2})T.+$/i)
    strategy :github_latest do |json, regex|
      json["published_at"]&.scan(regex)&.map { |match| match[0].tr("-", "") }
    end
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "c5797a1e8e13b35bfb400c09bd783382c517006dafae47a33204a1f292faddd0"
    sha256 cellar: :any,                 arm64_sequoia:  "5448f9dfdd462014fca6f549d3d8e42a8831e7af763ec90ec55d5f9de259a171"
    sha256 cellar: :any,                 arm64_sonoma:   "d066bb2e2067e8487d5e161c2c0d438ac331f377b4103833ee4859c6d680540a"
    sha256 cellar: :any,                 arm64_ventura:  "0a4fd034a7098d204a0b3c772023f6bc35f024e2f048216fdfe8e589f38cf2a8"
    sha256 cellar: :any,                 arm64_monterey: "3e92d822c2e0c5d314a92e5e26df14b3a84774494fb100f401c3a2d0c7e54768"
    sha256 cellar: :any,                 arm64_big_sur:  "6875acb418a0c10026c5356fe927a7c91a1825d8b314599ee1a64a309f30ed77"
    sha256 cellar: :any,                 sonoma:         "405046b352e922c38c294c48962a80f041156fc0f56991122fe86f996588c47c"
    sha256 cellar: :any,                 ventura:        "6fc9d75c64dc7690bf5c6b4d07642b65cee5f5a7cd582e59dfa22cb5cf8cac07"
    sha256 cellar: :any,                 monterey:       "db7acb62fe52ebc6b315b9e1e94cbf5ead317e7856af95efa8d5eeb0a41f62bf"
    sha256 cellar: :any,                 big_sur:        "c1a63f10d7451ba663ad8d974a69d83091be30730ca962a2fbd0e36b95ab16d2"
    sha256 cellar: :any,                 catalina:       "4fbf676c46941de213b095ab74f0b4973e5984c2bbaa7679757b0db4b369480a"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "fca2b168c6149c388d0692cecce3959175ef8aeec053cb64c0fa653f2c6553a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "129967d8e801a766a2d8209dff39cc8358bff641249838682ac1a943d0b7d385"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "boost"

  uses_from_macos "expat"

  conflicts_with "nss", because: "both install `mangle` binaries"

  def install
    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", *std_configure_args
    system "make"
    system "make", "check"
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/mangle")
    assert_match "mangle is an (in-development) XSLT processor", output
  end
end
