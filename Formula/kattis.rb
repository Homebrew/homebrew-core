class Kattis < Formula
  desc "Command-line submission tool for the Kattis online judge"
  homepage "https://open.kattis.com/"
  url "https://open.kattis.com/download/submit.py?#{version}"
  version "40d54c"
  sha256 "e0077380c6e479c03c631caf652f02e0d85d5ae288b4f4a79c285bb22f3bc3f5"

  def install
    bin.install "submit.py" => "kattis"
  end

  test do
    system "#{bin}/kattis", "-h"
  end
end
