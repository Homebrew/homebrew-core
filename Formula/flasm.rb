class Flasm < Formula
  desc "Flash command-line assembler and disassembler"
  homepage "https://www.nowrap.de/flasm.html"
  url "https://www.nowrap.de/download/flasm16src.zip"
  version "1.62"
  sha256 "df1273a506e2479cf95775197f5b7fa94e29fe1e0aae5aa190ed5bbebc4be5c6"

  bottle do
    sha256 cellar: :any_skip_relocation, catalina:    "8b12bb8f245caede2fa69847f452e4d8cbf75d1e52ceaf168272239a318c528f"
    sha256 cellar: :any_skip_relocation, mojave:      "4f2ad8d2f363f8509f3ec3f97f73773a5b21b893f954da011c431feb3c65aa02"
    sha256 cellar: :any_skip_relocation, high_sierra: "5461503d625b8b25339ac3a518c9079bfc92d4121760c61ef73f69020e2669b2"
    sha256 cellar: :any_skip_relocation, sierra:      "423b77912442f613cec430a8eee149783047f6b1a32d82d4b2920969fb6ca77e"
    sha256 cellar: :any_skip_relocation, el_capitan:  "44aa3b83ee62932fea2f1b3139b2fe391c59bba92f890121eca35e2736214b52"
    sha256 cellar: :any_skip_relocation, yosemite:    "b2ae27971e7fa4a731000eeda0cd7a8fb75cbe55d013af3c2d9d0cc3b2bc405f"
  end

  disable! date: "2020-12-08", because: :unmaintained

  def install
    system "make", "CC=#{ENV.cc}", "CFLAGS=#{ENV.cflags}"
    bin.install "flasm"
  end

  test do
    (testpath/"test").write <<~EOS
      constants 'a', 'b'
      push 'a', 'b'
      getVariable
      push 'b'
      getVariable
      multiply
      setVariable
    EOS

    system "#{bin}/flasm", "-b", "test"
  end
end
