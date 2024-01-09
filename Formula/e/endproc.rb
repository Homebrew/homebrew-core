class EndProc < Formula
  desc "Well formatted command line tool to view your running proccesses with their PIDS and ports and also kill the process if you want to ."
  homepage "https://github.com/ikotun-dev/port.shield"
  url "https://github.com/ikotun-dev/port.shield/archive/refs/tags/v1.1.0.zip"
  sha256 "6716c58c87d7c2ffd93afe2adcd4610c6016fa889d604430f3869d71f52735b5"
  depends_on "python"


 def install
   bin.install "main.py" => "endproc"  # Update with your script filename
  end

  test do
    system "#{bin}/endproc", "--version"
  end
end

