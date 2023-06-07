class Dbacl < Formula
  desc "Digramic Bayesian classifier"
  homepage "https://dbacl.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/dbacl/dbacl/1.14.1/dbacl-1.14.1.tar.gz"
  sha256 "ff0dfb67682e863b1c3250acc441ce77c033b9b21d8e8793e55b622e42005abd"
  license "GPL-3.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "09a812fe378bbee0cfaeb31af232529e2e682379077a6435fcd2acb268047825"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "66ed22f1faf6f76848af60768dc3cd915f92859fb4c527657e06768d0499e443"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "267668662863b785760b49c085001924efb548d2a01e9be3a14e330233a58943"
    sha256 cellar: :any_skip_relocation, ventura:        "016b9c97da07866abe32a76f55a0e8e28744cb34aa5a71eae7e3b2033f8a71d7"
    sha256 cellar: :any_skip_relocation, monterey:       "70c98f90cec395f2366d669999f11334f95c8e97657f9845307c3bc37d67278a"
    sha256 cellar: :any_skip_relocation, big_sur:        "643c9891b075b1f8a766269cc1a9f5ec6b541e23055124f7cb2d289650bf08d0"
    sha256 cellar: :any_skip_relocation, catalina:       "d81fd1fc86703610737cfd9d24f8c3c8db2e97ef4148f1f7f91a43c81c8762c6"
    sha256 cellar: :any_skip_relocation, mojave:         "8a64ac80e91d8d5b2366046096098b851d503c58af65ef0858834c5794d039a5"
    sha256 cellar: :any_skip_relocation, high_sierra:    "42c1c03e8df0b4db91dc99ace3ec87f3901f1aa6975430d597240ab5f9182c1f"
    sha256 cellar: :any_skip_relocation, sierra:         "c6e6d74e2f2a86325ee895f8ef6893d99e1463d0018ead0d0da46e0dfd95c272"
    sha256 cellar: :any_skip_relocation, el_capitan:     "750c29761c5784ddbd0d46643f2d462d8b22c14822773e2366db01be17a3e310"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "27ddb0fca1dfb2cc615befe472927ff657b689dad255e26913ce118f7d83dfcb"
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"mark-twain.txt").write <<~EOS
      The report of my death was an exaggeration.
      The secret of getting ahead is getting started.
      Travel is fatal to prejudice, bigotry, and narrow-mindedness.
      I have never let my schooling interfere with my education.
      Whenever you find yourself on the side of the majority, it is time to pause and reflect.
      Kindness is the language which the deaf can hear and the blind can see.
      The two most important days in your life are the day you are born and the day you find out why.
      Truth is stranger than fiction, but it is because Fiction is obliged to stick to possibilities; Truth isn't.
      If you tell the truth, you don't have to remember anything.
      It's not the size of the dog in the fight, it's the size of the fight in the dog.
    EOS

    (testpath/"william-shakespeare.txt").write <<~EOS
      Hell is empty and all the devils are here.
      All that glitters is not gold
      To thine own self be true, and it must follow, as the night the day, thou canst not then be false to any man.
      Love all, trust a few, do wrong to none.
      To be, or not to be, that is the question
      Be not afraid of greatness: some are born great, some achieve greatness, and some have greatness thrust upon them.
      The lady doth protest too much, methinks.
      So full of artless jealousy is guilt, It spills itself in fearing to be spilt.
      If music be the food of love, play on.
      There is nothing either good or bad, but thinking makes it so.
      The course of true love never did run smooth.
    EOS

    system "#{bin}/dbacl", "-l", "twain", "mark-twain.txt"
    system "#{bin}/dbacl", "-l", "shake", "william-shakespeare.txt"

    output = pipe_output("#{bin}/dbacl -v -c twain -c shake", "to be or not to be")
    assert_equal "shake", output.strip
  end
end
