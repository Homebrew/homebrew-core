class CombineTextFiles < Formula
  desc "A tool to combine text files with delimiters"
  homepage "https://github.com/orhanerday/combine-text-files"
  url "https://codeload.github.com/orhanerday/combine-text-files/tar.gz/refs/tags/v2.2"
  sha256 "05ba5af21208caa5ac965e6c2e1495d55462f92f60c8ac79143d2ab19671e379"
  license "MIT"

  def install
    system "make"
    bin.install "combine-text-files"
  end

  test do
    (testpath/"testfile.txt").write("This is a test file.")
    system "#{bin}/combine-text-files"
    assert_predicate testpath/"single_file.txt", :exist?
  end
end
