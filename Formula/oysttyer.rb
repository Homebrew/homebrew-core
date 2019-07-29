class Oysttyer < Formula
  desc "Command-line Twitter client"
  homepage "https://github.com/oysttyer/oysttyer"
  url "https://github.com/oysttyer/oysttyer/archive/2.10.0.tar.gz"
  sha256 "3c0ce1c7b112f2db496cc75a6e76c67f1cad956f9e7812819c6ae7a979b2baea"
  head "https://github.com/oysttyer/oysttyer.git"

  bottle :unneeded

  def install
    bin.install "oysttyer.pl" => "oysttyer"
  end

  test do
    IO.popen("#{bin}/oysttyer", "r+") do |pipe|
      assert_equal "-- using SSL for default URLs.", pipe.gets.chomp
      pipe.puts "^C"
      pipe.close_write
    end
  end
end
