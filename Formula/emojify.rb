class Emojify < Formula
  desc "Emoji on the command-line :scream:"
  homepage "https://github.com/mrowa44/emojify"
  url "https://github.com/mrowa44/emojify/archive/2.1.0.tar.gz"
  sha256 "f5d37f99b598975179991a3f569d21e7f1aaf481dbf12f4108fc7bfdab93d0fc"
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
