class Apkparser < Formula
  desc "Android apk file parsing tool"
  homepage "https://github.com/wswenyue/apkparser"
  url "https://github.com/wswenyue/apkparser/archive/apkparser-1.0.0.tar.gz"
  sha256 "c002f5f735e1d30502acf06206d0fda05beba1976ede4581250f0ddbc9056a1b"

  def install
    libexec.install Dir["*"]
    bin.install libexec/"apkparser" => "apkparser"
    inreplace bin/"apkparser", "exe_path", "#{libexec}"
  end

  test do
    system "false"
  end
end
