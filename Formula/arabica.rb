class Arabica < Formula
  desc "XML toolkit written in C++"
  homepage "https://www.jezuk.co.uk/tags/arabica.html"
  url "https://github.com/jezhiggins/arabica/archive/2020-April.tar.gz"
  version "20200425"
  sha256 "b00c7b8afd2c3f17b5a22171248136ecadf0223b598fd9631c23f875a5ce87fe"
  license "BSD-3-Clause"
  head "https://github.com/jezhiggins/arabica.git", branch: "main"

  # The `strategy` block below is used to generate a version from the datetime
  # of the "latest" release on GitHub, so it will match the formula `version`.
  livecheck do
    url :stable
    regex(/datetime=["']?(\d{4}-\d{2}-\d{2})T/i)
    strategy :github_latest do |page, regex|
      page.scan(regex).map { |match| match&.first&.gsub(/\D/, "") }
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "3e92d822c2e0c5d314a92e5e26df14b3a84774494fb100f401c3a2d0c7e54768"
    sha256 cellar: :any,                 arm64_big_sur:  "6875acb418a0c10026c5356fe927a7c91a1825d8b314599ee1a64a309f30ed77"
    sha256 cellar: :any,                 monterey:       "db7acb62fe52ebc6b315b9e1e94cbf5ead317e7856af95efa8d5eeb0a41f62bf"
    sha256 cellar: :any,                 big_sur:        "c1a63f10d7451ba663ad8d974a69d83091be30730ca962a2fbd0e36b95ab16d2"
    sha256 cellar: :any,                 catalina:       "4fbf676c46941de213b095ab74f0b4973e5984c2bbaa7679757b0db4b369480a"
    sha256 cellar: :any,                 mojave:         "acc299016dbd644658880e9fa29af6d3f0b9f8e226b16ccd3fcaea8dae23febf"
    sha256 cellar: :any,                 high_sierra:    "62920d4f26c2da71c6abf60c90c1322457e340df8142d7133a9ee1f7c2b46745"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "129967d8e801a766a2d8209dff39cc8358bff641249838682ac1a943d0b7d385"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "boost"

  uses_from_macos "expat"

  def install
    system "autoreconf", "-fvi"
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make"
    system "make", "check"
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/mangle")
    assert_match "mangle is an (in-development) XSLT processor", output
  end
end
