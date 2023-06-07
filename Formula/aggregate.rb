class Aggregate < Formula
  desc "Optimizes lists of prefixes to reduce list lengths"
  homepage "https://web.archive.org/web/20160716192438/freecode.com/projects/aggregate/"
  url "https://ftp.isc.org/isc/aggregate/aggregate-1.6.tar.gz"
  sha256 "166503005cd8722c730e530cc90652ddfa198a25624914c65dffc3eb87ba5482"
  license "ISC"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7ed5b3fee9fdcadb6278923b3776739ef63226ae5ad3dbc024ddfc54e1eea0fc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "387184c17669967eb2af11d108d5bd53294ea7163a19ec3a2519449e3f8c24a6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "429949518b51d72ff7e05ebe6b0ae77a11d7aa593bcec67e0edd6477fe273a8d"
    sha256 cellar: :any_skip_relocation, ventura:        "33fa5a424f83152abf9eaaa93383cc165263e7404bbceae7f7ea84873cbe5f2d"
    sha256 cellar: :any_skip_relocation, monterey:       "b8cb4e13724b2c45889b17303bb378dd6444557aa0a0c3bb7a100643aabbde49"
    sha256 cellar: :any_skip_relocation, big_sur:        "ab6914ea220f96d957eb322596ddc34fb72e8beedaed0bc21ee5dbfb2d0c64ca"
    sha256 cellar: :any_skip_relocation, catalina:       "3e22a340761b031b33e9f4a48f39edd98c18f7ea7c77abd02d95f816e7fe7245"
    sha256 cellar: :any_skip_relocation, mojave:         "231a7cce3160591eff39c8f70a9324dd0329a6a21355d49747c74308527cc946"
    sha256 cellar: :any_skip_relocation, high_sierra:    "6dc7626282f519003e1d559ac42a983f4a571494ac04e5b61858fdf16d1ca924"
    sha256 cellar: :any_skip_relocation, sierra:         "ebe7aa16c7cf36684463292995c60fdde12cdac889de551d8f85b89e6b77416c"
    sha256 cellar: :any_skip_relocation, el_capitan:     "87507a739f2bd5ba57ccd23b34f2b7c41d68a897c128231dbbc32ba23b869ed5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ed89de5c64cf464e1002d2b16aaa6749a68b113199dd702077a36db84a1a7ae1"
  end

  conflicts_with "crush-tools", because: "both install an `aggregate` binary"

  def install
    bin.mkpath
    man1.mkpath

    # Makefile doesn't respect --mandir or MANDIR
    inreplace "Makefile.in", "$(prefix)/man/man1", "$(prefix)/share/man/man1"

    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "CFLAGS=#{ENV.cflags}",
                   "LDFLAGS=#{ENV.ldflags}",
                   "install"
  end

  test do
    # Test case taken from here: https://horms.net/projects/aggregate/examples.shtml
    test_input = <<~EOS
      10.0.0.0/19
      10.0.255.0/24
      10.1.0.0/24
      10.1.1.0/24
      10.1.2.0/24
      10.1.2.0/25
      10.1.2.128/25
      10.1.3.0/25
    EOS

    expected_output = <<~EOS
      10.0.0.0/19
      10.0.255.0/24
      10.1.0.0/23
      10.1.2.0/24
      10.1.3.0/25
    EOS

    assert_equal expected_output, pipe_output("#{bin}/aggregate", test_input), "Test Failed"
  end
end
