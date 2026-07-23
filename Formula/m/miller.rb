class Miller < Formula
  desc "Like sed, awk, cut, join & sort for name-indexed data such as CSV"
  homepage "https://github.com/johnkerl/miller"
  url "https://github.com/johnkerl/miller/archive/refs/tags/v6.20.2.tar.gz"
  sha256 "3fe628547293f1c70c70593961277e3e27940c4968a6115304251a0b494acd30"
  license "BSD-2-Clause"
  head "https://github.com/johnkerl/miller.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f8f074e0a6793c196f491dfffcfc1af93fa61ff6bd4f2ca60ecc588cd2da7c2e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "96d19572e8ddcc42cec67d6970332072299dd143acf76af084b2b7a7d0612264"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1844529fc61c8f2d907b21ba9343ece0cb316ee19be4714d0e21fc1bafdb0c4d"
    sha256 cellar: :any_skip_relocation, sonoma:        "2b8b76880c16f3f0c80482cba0cc15274d401a95334c59ce896a228f4d0b3ba0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "835619b0aaa541cd88e5f10ba8595b74b8d336c2b6d83b6a8511c70cc2476d64"
    sha256 cellar: :any,                 x86_64_linux:  "e619fd6942ade819447e54562c5159420db48a54341dc1fa00f5b1c66edb3bd0"
  end

  depends_on "go" => :build

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.csv").write <<~CSV
      a,b,c
      1,2,3
      4,5,6
    CSV
    output = pipe_output("#{bin}/mlr --csvlite cut -f a test.csv")
    assert_match "a\n1\n4\n", output
  end
end
