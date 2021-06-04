class Emojify < Formula
  desc "Emoji on the command-line :scream:"
  homepage "https://github.com/mrowa44/emojify"
  url "https://github.com/mrowa44/emojify/archive/v1.0.2.tar.gz"
  sha256 "a75d49d623f92974d7852526591d5563c27b7655c20ebdd66a07b8a47dae861c"
  license "MIT"
  head "https://github.com/mrowa44/emojify.git"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "525c599c9e16d63627d5b4afca9f43d22e456d21a8e00a05b5e4a4e2acded629"
  end

  def install
    bin.install "emojify"
  end

  test do
    input = "Hey, I just :raising_hand: you, and this is :scream: , but here's my :calling: , "\
            "so :telephone_receiver: me, maybe?"
    assert_equal "Hey, I just 🙋 you, and this is 😱 , but here's my 📲 , so 📞 me, maybe?",
      shell_output("#{bin}/emojify \"#{input}\"").strip
  end
end
