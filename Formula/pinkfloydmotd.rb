class Pinkfloydmotd < Formula
  desc "Program to generate dynamic qoutes based on pinkfloyd's music"
  homepage "https://github.com/skashyap7/PinkFloydMOTD"
  url "https://github.com/skashyap7/PinkFloydMOTD/raw/master/pinkfloydmotd.zip"
  version "1.0.0"
  sha256 "9d2202eb2b479086f355e91bfd3e074081d40fb6b50711fa5b1aa83ebf040a7d"
  depends_on "python"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "false"
  end
end
