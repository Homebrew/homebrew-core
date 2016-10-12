class Imgcat < Formula
  desc "Displays one or more images inline at their full size."
  homepage "https://www.iterm2.com/documentation-images.html"
  url "https://raw.githubusercontent.com/gnachman/iTerm2/master/tests/imgcat"
  version "0.0.1"
  sha256 "5d471f24d512143796b81de873fb7b6660b0a57bc1c99bb26fd1c9ef8dff64de"

  depends_on "bash" => :run

  def install
    bin.install "imgcat"
  end

  test do
    touch "test.png"
    system "imgcat", "test.png"
  end
end
