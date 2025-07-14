class Miller < Formula
  desc "Like sed, awk, cut, join & sort for name-indexed data such as CSV"
  homepage "https://github.com/johnkerl/miller"
  url "https://github.com/johnkerl/miller/archive/refs/tags/v6.14.0.tar.gz"
  sha256 "2009b845cf0e397fb82e510ba0a191d8c355e2abf221fb61134aac7ce3bd6c71"
  license "BSD-2-Clause"
  head "https://github.com/johnkerl/miller.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9f54d8db973db256344b08ae68f5497be7ee0fad34311bfceb45fabd0d11f22c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6c01fae53b921f8fe7c77226a4ecd08e27e7b4679d92f98517dfab3b41b7426e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "355c0b2f7f617f457efef03a1bec6bf1a2710b5b0ea3e98af00729a6eee8e2c5"
    sha256 cellar: :any_skip_relocation, sonoma:        "15fb079f364863446b5ab283b5d7f6eec16aafb7ee95ae934704ede5261a8647"
    sha256 cellar: :any_skip_relocation, ventura:       "0b1bcf75feed4355185d86363a7e73f9416304d21f228e6ffd875383610a11f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d27c305e6e23dd5692d961ff832f41f7e6b12a477e3b41ea16ae9127b3715751"
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
