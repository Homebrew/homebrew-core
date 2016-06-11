class Emojify < Formula
  desc "Emoji on the command-line :scream:"
  homepage "https://github.com/mrowa44/emojify"
  url "https://github.com/mrowa44/emojify/archive/v1.0.1.tar.gz"
  sha256 "c711025cd92834c21c8292994d436b2f702dd482b5577ea086748fa04705dacf"
  head "https://github.com/mrowa44/emojify.git"

  bottle :unneeded

  def install
    bin.install "emojify"
  end

  test do
    input = "Hey, I just :raising_hand: you, and this is :scream: , but here's my :calling: , so :telephone_receiver: me, maybe?"
    expected = "Hey, I just 🙋 you, and this is 😱 , but here's my 📲 , so 📞 me, maybe?"
    assert_equal(expected, shell_output("#{bin}/emojify \"#{input}\"").strip)
  end
end
