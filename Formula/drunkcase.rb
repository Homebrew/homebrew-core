class Drunkcase < Formula
  desc "Modify text by randomly manipulating it's case"
  homepage "https://github.com/bbriano/drunkcase"
  url "https://github.com/bbriano/drunkcase/releases/download/v0.1.0/drunkcase.tar.gz"
  sha256 "b453a490c7d6fd80b43926d00e1ec140178fa793182c7d0131c4f54ce18172d8"

  def install
    bin.install "drunkcase"
  end

  test do
    random_lowercase_string = (0...50).map { ("a".."z").to_a[rand(26)] }.join
    assert_equal pipe_output(
      "#{bin}/drunkcase",
      random_lowercase_string,
      nil,
    ).downcase, random_lowercase_string
  end
end
