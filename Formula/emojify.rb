class Emojify < Formula
  desc "Emoji on the command-line :scream:"
  homepage "https://github.com/mrowa44/emojify"
  url "https://github.com/mrowa44/emojify/archive/v1.0.0.tar.gz"
  sha256 "fabefc4767428a2634a77e7845e315725b75b50f282d0943c5b65789650c25d1"
  head "https://github.com/mrowa44/emojify.git"

  def install
    bin.install "emojify"
  end

  test do
    assert_equal("Hey, I just 🙋 you, and this is 😱 , but here's my 📲 , so 📞 me, maybe?", shell_output("#{bin}/emojify \"Hey, I just :raising_hand: you, and this is :scream: , but here's my :calling: , so :telephone_receiver: me, maybe?\"").strip)
  end
end
