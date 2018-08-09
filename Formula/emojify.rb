class Emojify < Formula
  desc "Emoji on the command-line :scream:"
  homepage "https://github.com/mrowa44/emojify"
  url "https://github.com/mrowa44/emojify/archive/2.0.0.tar.gz"
  sha256 "61f4532381d5505511f752ff1f867ceeb0f1921a3e68716bea11185fbd730cbb"
  head "https://github.com/mrowa44/emojify.git"

  bottle :unneeded

  depends_on "bash"

  def install
    (libexec/"bin").install "emojify"
    bin.env_script_all_files(libexec/"bin", :PATH => "#{Formula["bash"].opt_bin}:$PATH")
  end

  test do
    input = "Hey, I just :raising_hand: you, and this is :scream: , but here's my :calling: , so :telephone_receiver: me, maybe?"
    expected = "Hey, I just 🙋 you, and this is 😱 , but here's my 📲 , so 📞 me, maybe?"
    assert_equal(expected, shell_output("#{bin}/emojify \"#{input}\"").strip)
  end
end
