class PutmailQueue < Formula
  desc "Queue package for putmail"
  homepage "https://putmail.sourceforge.net/home.html"
  url "https://downloads.sourceforge.net/project/putmail/putmail-queue/0.2/putmail-queue-0.2.tar.bz2"
  sha256 "09349ad26345783e061bfe4ad7586fbbbc5d1cc48e45faa9ba9f667104f9447c"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "6fc472e77db929384f6f9e436b6a3433df05d86cc583e499f92bd69373d332c3"
  end

  # putmail-queue doesn't support Python 3
  disable! date: "2024-07-03", because: :unsupported

  depends_on "putmail"

  def install
    bin.install "putmail_dequeue.py", "putmail_enqueue.py"
    man1.install Dir["man/man1/*.1"]
  end
end
