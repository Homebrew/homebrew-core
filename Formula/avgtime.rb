class Avgtime < Formula
  desc "Like unix 'time' command, but with repetitions, median, std deviation"
  homepage "https://github.com/jmcabo/avgtime"
  url "https://github.com/jmcabo/avgtime.git", :revision => "ffdf20049db7a6aa6074354d95265869c6aad65b"
  version "0.6.0-dev"

  depends_on "dmd" => :build

  def install
    system "dmd", "./avgtime.d"
    bin.install "avgtime"
  end

  test do
    system "#{bin}/avgtime", "-r", "10", "ls"
  end
end
